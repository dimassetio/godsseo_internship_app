import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/dropdown_menu.dart';
import 'package:godsseo/app/data/widgets/form_foto.dart';
import 'package:godsseo/app/data/widgets/text_field.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/users_form_controller.dart';

class UsersFormView extends GetView<UsersFormController> {
  const UsersFormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.isEdit ? 'Edit' : 'Tambah'} Users'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Obx(
                  () => CircleAvatar(
                      backgroundColor: primaryColor(context),
                      child:
                          (controller.editedUser?.foto?.isEmptyOrNull ?? true)
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                )
                              : null,
                      backgroundImage:
                          (controller.editedUser?.foto?.isEmptyOrNull ?? true)
                              ? null
                              : CachedNetworkImageProvider(
                                  controller.editedUser!.foto!),
                      foregroundImage: controller.selectedPhotoPath.isEmpty
                          ? null
                          : FileImage(File(controller.selectedPhotoPath.value)),
                      radius: 60),
                ),
                16.height,
                ElevatedButton(
                    onPressed: () async {
                      var result = await imagePickerBottomSheet(context);
                      if (result is XFile) {
                        controller.selectedPhotoPath.value = result.path;
                      }
                    },
                    child: Text("Upload foto")),
                16.height,
                GSCardColumn(
                  children: [
                    GSTextField(
                      icon: Icon(Icons.person),
                      label: "Username",
                      controller: controller.usernameC,
                    ),
                    16.height,
                    GSTextField(
                      icon: Icon(Icons.person),
                      label: "Nama Lengkap",
                      controller: controller.fullnameC,
                    ),
                    16.height,
                    GSDropdown(
                      listValue: controller.genderList,
                      onChanged: (value) {
                        controller.selectedGender = value;
                      },
                      initValue: controller.selectedGender,
                      label: "Gender",
                      icon: Icon(Icons.male),
                    ),
                    16.height,
                    GSTextField(
                      icon: Icon(Icons.map),
                      label: "Alamat",
                      controller: controller.alamatC,
                    ),
                  ],
                ),
                16.height,
                GSCardColumn(
                  children: [
                    GSTextField(
                      icon: Icon(Icons.school),
                      label: "Asal Sekolah",
                      controller: controller.sekolahC,
                    ),
                    16.height,
                    GSTextField(
                      isReadOnly: true,
                      onTap: () async {
                        var res = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2010),
                            lastDate: DateTime(DateTime.now().year + 1));
                        if (res is DateTime) {
                          controller.selectedTglMasuk = res;
                          controller.tglMasukC.text = dateFormatter(res);
                        }
                      },
                      controller: controller.tglMasukC,
                      icon: Icon(Icons.date_range),
                      label: "Tanggal Masuk",
                    ),
                  ],
                ),
                16.height,
                GSCardColumn(
                  children: [
                    GSTextField(
                      isValidationRequired: !controller.isEdit,
                      isEnabled: !controller.isEdit,
                      icon: Icon(Icons.email_rounded),
                      label: "Email",
                      controller: controller.emailC,
                    ),
                    16.height,
                    GSDropdown(
                      listValue: ["Active", "Nonactive"],
                      onChanged: (value) {
                        controller.isActive = value == "Active";
                      },
                      initValue: controller.isActive == null
                          ? null
                          : (controller.isActive ?? false)
                              ? "Active"
                              : "Nonactive",
                      label: "Status",
                      icon: Icon(Icons.check_circle_outline_rounded),
                    ),
                    16.height,
                    GSDropdown(
                      listValue: Role.list,
                      onChanged: (value) {
                        controller.selectedRole = value;
                      },
                      initValue: controller.selectedRole,
                      label: "Role",
                      icon: Icon(Icons.admin_panel_settings),
                    ),
                  ],
                ),
                if (!controller.isEdit)
                  GSCardColumn(
                    margin: EdgeInsets.only(top: 16),
                    children: [
                      16.height,
                      GSTextField(
                        isValidationRequired: !controller.isEdit,
                        isEnabled: !controller.isEdit,
                        textFieldType: TextFieldType.PASSWORD,
                        icon: Icon(Icons.lock),
                        controller: controller.passwordC,
                        label: "Password",
                      ),
                      16.height,
                      GSTextField(
                        isValidationRequired: !controller.isEdit,
                        isEnabled: !controller.isEdit,
                        controller: controller.confirmPasswordC,
                        validator: (value) => value == controller.passwordC.text
                            ? null
                            : "Password does not match",
                        textFieldType: TextFieldType.PASSWORD,
                        icon: Icon(Icons.lock),
                        label: "Confirm Password",
                      ),
                    ],
                  ),
                16.height,
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () async {
                              if (controller.formKey.currentState?.validate() ??
                                  false) {
                                await controller.save();
                                Get.back();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: controller.isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(),
                            )
                          : Text("Submit"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
