import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/button.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/circle_container.dart';
import 'package:godsseo/app/data/widgets/text_field.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/pengaturan_controller.dart';

class PengaturanView extends GetView<PengaturanController> {
  const PengaturanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Presensi'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Obx(
                () => GSCardColumn(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.settings, color: primaryColor(context)),
                            8.width,
                            Text(
                              "Pengaturan Presensi".tr,
                              style: textTheme(context).titleMedium,
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            controller.isEdit = !controller.isEdit;
                          },
                          icon: Icon(
                              controller.isEdit
                                  ? Icons.clear_rounded
                                  : Icons.edit,
                              color: primaryColor(context)),
                        )
                      ],
                    ),
                    GSTextField(
                      label: "Waktu Masuk".tr,
                      icon: Icon(Icons.access_time),
                      controller: controller.timeInC,
                      isEnabled: controller.isEdit,
                      onTap: () async {
                        var time = await controller.pickTime(
                            context, controller.selectedTimeIn.value);
                        if (time is TimeOfDay) {
                          controller.selectedTimeIn.value = time;
                          controller.timeInC.text =
                              timeFormatter(timeToDate(time));
                        }
                      },
                    ),
                    8.height,
                    GSTextField(
                      label: "Waktu Keluar".tr,
                      icon: Icon(Icons.access_time),
                      controller: controller.timeOutC,
                      isEnabled: controller.isEdit,
                      onTap: () async {
                        var time = await controller.pickTime(
                            context, controller.selectedTimeOut.value);
                        if (time is TimeOfDay) {
                          controller.selectedTimeOut.value = time;
                          controller.timeOutC.text =
                              timeFormatter(timeToDate(time));
                        }
                      },
                    ),
                    8.height,
                    GSTextField(
                      label: "Lokasi".tr,
                      icon: Icon(Icons.pin_drop),
                      controller: controller.lokasiC,
                      isEnabled: controller.isEdit,
                    ),
                    12.height,
                    Row(
                      children: [
                        Icon(Icons.calendar_view_week_rounded),
                        12.width,
                        Text(
                          "Libur Mingguan".tr,
                          style: textTheme(context).labelLarge,
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        int value = index + 1;
                        return Obx(() {
                          bool isSelected =
                              controller.selectedWeeklyOff.contains(value);
                          if (!controller.isEdit && !isSelected) {
                            return SizedBox.shrink();
                          }
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: !controller.isEdit
                                ? null
                                : (res) {
                                    if (isSelected) {
                                      controller.selectedWeeklyOff
                                          .remove(value);
                                    } else {
                                      controller.selectedWeeklyOff = [
                                        ...controller.selectedWeeklyOff,
                                        value
                                      ];
                                    }
                                  },
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(getDayName(value)),
                          );
                        });
                      },
                    ),
                    if (controller.isEdit)
                      GSButton(
                        title:
                            controller.isLoading ? "Loading".tr : "Simpan".tr,
                        icon: controller.isLoading
                            ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator())
                            : Icon(Icons.save),
                        onPressed: controller.isLoading
                            ? null
                            : () {
                                controller.saveRules();
                              },
                      ).marginOnly(top: 12),
                  ],
                ),
              ),
              Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.today, color: primaryColor(context)),
                      8.width,
                      Text(
                        "Hari Libur".tr,
                        style: textTheme(context).titleMedium,
                      ),
                    ],
                  ),
                  GSButton(
                      title: "Tambah".tr,
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        Get.toNamed(Routes.DAYOFF);
                      })
                ],
              ),
              16.height,
              Obx(
                () => controller.daysoff.isEmpty
                    ? Text("Belum ada hari libur")
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: controller.daysoff.length,
                        itemBuilder: (context, index) {
                          var data = controller.daysoff[index];
                          return GSCardColumn(
                            margin: EdgeInsets.only(bottom: 12),
                            onTap: () {},
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateFormatter(data.date, withDays: true),
                                    style: textTheme(context).titleMedium,
                                  ),
                                  CircleContainer(
                                    color: primaryColor(context),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 8),
                                    child: Text(
                                      data.description ?? '',
                                      style: textTheme(context)
                                          .bodyMedium
                                          ?.copyWith(
                                              color: colorScheme(context)
                                                  .onPrimary),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Obx(
                  () => TextButton(
                      onPressed: () {
                        controller.showPast = !controller.showPast;
                      },
                      child: Text(controller.showPast
                          ? "Sembunyikan Kemarin".tr
                          : "Tampilkan Kemarin".tr)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
