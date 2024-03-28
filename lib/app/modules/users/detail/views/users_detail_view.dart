import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/text_field.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/users_detail_controller.dart';

class UsersDetailView extends GetView<UsersDetailController> {
  const UsersDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Users'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                _buildPopUpMenuItem(context, icon: Icons.edit, title: "Edit",
                    function: () {
                  Get.offNamed(Routes.USERS_FORM, arguments: controller.user);
                }),
                _buildPopUpMenuItem(
                  context,
                  icon: Icons.lock_reset,
                  title: "Reset Password",
                  function: () async {
                    controller.resetPassword(context);
                  },
                ),
                _buildPopUpMenuItem(
                  context,
                  icon: Icons.delete,
                  title: "Nonaktifkan",
                  function: () async {
                    await controller.disableUser(context);
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: primaryColor(context),
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                  foregroundImage: (controller.user?.foto.isEmptyOrNull ?? true)
                      ? null
                      : CachedNetworkImageProvider(controller.user!.foto!),
                  radius: 60),
              16.height,
              GSCardColumn(
                children: [
                  GSTextField(
                    icon: Icon(
                      Icons.person,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.nickname,
                    label: "Username",
                  ),
                  16.height,
                  GSTextField(
                    icon: Icon(
                      Icons.person,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.nama,
                    label: "Nama Lengkap",
                  ),
                  16.height,
                  GSTextField(
                    icon: Icon(
                      controller.user?.gender == "Laki-Laki"
                          ? Icons.male
                          : Icons.female,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.gender,
                    label: "Gender",
                  ),
                  16.height,
                  GSTextField(
                    icon: Icon(
                      Icons.map,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.alamat,
                    label: "Alamat",
                  ),
                ],
              ),
              16.height,
              GSCardColumn(
                children: [
                  GSTextField(
                    icon: Icon(
                      Icons.school,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.sekolah,
                    label: "Asal Sekolah",
                  ),
                  16.height,
                  GSTextField(
                    isReadOnly: true,
                    icon: Icon(
                      Icons.date_range,
                      color: primaryColor(context),
                    ),
                    initValue: dateFormatter(controller.user?.tglMasuk),
                    label: "Tanggal Masuk",
                  ),
                ],
              ),
              16.height,
              GSCardColumn(
                children: [
                  GSTextField(
                    icon: Icon(
                      Icons.email_rounded,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.email,
                    label: "Email",
                  ),
                  16.height,
                  GSTextField(
                    initValue: (controller.user?.isActive ?? false)
                        ? "Active"
                        : "Nonactive",
                    label: "Status",
                    icon: Icon(
                      Icons.check_circle_outline_rounded,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                  ),
                  16.height,
                  GSTextField(
                    label: "Role",
                    icon: Icon(
                      Icons.admin_panel_settings,
                      color: primaryColor(context),
                    ),
                    isReadOnly: true,
                    initValue: controller.user?.role,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<dynamic> _buildPopUpMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required void Function() function}) {
    return PopupMenuItem(
        onTap: function,
        child: Row(
          children: [
            Icon(
              icon,
              color: primaryColor(context),
            ),
            16.width,
            Text(title),
          ],
        ));
  }
}
