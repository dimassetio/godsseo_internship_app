import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/widgets/button.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/text_field.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/dayoff_controller.dart';

class DayoffView extends GetView<DayoffController> {
  const DayoffView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Form Hari Libur'.tr),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Obx(
                    () => GSCardColumn(
                      children: [
                        GSTextField(
                          label: "Tanggal".tr,
                          isValidationRequired: true,
                          icon: Icon(Icons.calendar_today),
                          controller: controller.tanggalC,
                          isReadOnly: true,
                          onTap: controller.isLoading
                              ? null
                              : () async {
                                  await controller.pickDate(context);
                                },
                        ),
                        16.height,
                        GSTextField(
                          label: "Deskripsi".tr,
                          icon: Icon(Icons.info_outline_rounded),
                          controller: controller.deskripsiC,
                          isValidationRequired: true,
                        ),
                        16.height,
                        GSButton(
                          title: "Simpan".tr,
                          onPressed: controller.isLoading
                              ? null
                              : () {
                                  if (controller.formKey.currentState
                                          ?.validate() ??
                                      false) {
                                    controller.save();
                                  }
                                },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
