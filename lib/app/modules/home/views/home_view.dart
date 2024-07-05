import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:godsseo/app/modules/home/views/presence_card.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // User Profile Section
                Obx(
                  () => ListTile(
                    title: Text(
                      "Halo,".trParams({'name': authC.user.nickname ?? ""}),
                      style: textTheme(context)
                          .titleLarge
                          ?.copyWith(color: primaryColor(context)),
                    ),
                    subtitle: Text(
                      "Lama magang".trParams(
                          {"name": authC.user.countInternDays().toString()}),
                      style: textTheme(context).labelLarge,
                    ),
                    trailing: CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
                16.height,
                // Today Presence Section
                GSCardColumn(
                  color: primaryColor(context),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: colorScheme(context).onPrimary,
                            ),
                            4.width,
                            Text(
                              "Hari ini".trParams(
                                  {"date": dateFormatter(DateTime.now())}),
                              style: textTheme(context).bodyMedium?.copyWith(
                                  color: colorScheme(context).onPrimary),
                            )
                          ],
                        ),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: colorScheme(context).onPrimary,
                              ),
                              4.width,
                              Text(
                                timeFormatter(controller.now, withSecond: true),
                                style: textTheme(context).bodyMedium?.copyWith(
                                    color: colorScheme(context).onPrimary),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    10.height,
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme(context).surface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Masuk".tr,
                                style: textTheme(context).labelMedium?.copyWith(
                                    color: colorScheme(context).onPrimary),
                              ),
                              Obx(
                                () => controller.todayPresensi == null
                                    ? SizedBox(
                                        width: 32,
                                        child: LinearProgressIndicator(),
                                      )
                                    : Text(
                                        timeFormatter(
                                            controller.todayPresensi?.dateIn,
                                            defaultText: '-- : --'),
                                        style: textTheme(context)
                                            .titleLarge
                                            ?.copyWith(
                                                color: colorScheme(context)
                                                    .onPrimary),
                                      ),
                              ),
                            ],
                          ),
                          Container(
                            height: 32,
                            width: 2,
                            color: colorScheme(context).onPrimary,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Keluar".tr,
                                style: textTheme(context).labelMedium?.copyWith(
                                    color: colorScheme(context).onPrimary),
                              ),
                              Obx(
                                () => controller.todayPresensi == null
                                    ? SizedBox(
                                        width: 32,
                                        child: LinearProgressIndicator(),
                                      )
                                    : Text(
                                        timeFormatter(
                                            controller.todayPresensi?.dateOut,
                                            defaultText: '-- : --'),
                                        style: textTheme(context)
                                            .titleLarge
                                            ?.copyWith(
                                                color: colorScheme(context)
                                                    .onPrimary),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(height: 32, thickness: 0.5),
                // Location Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => TextButton.icon(
                      icon: Icon(Icons.location_on_rounded),
                      onPressed: () {
                        controller.streamPosition();
                        // controller.isLoading.value =
                        //     !controller.isLoading.value;
                      },
                      label: controller.position.value == null
                          ? LinearProgressIndicator()
                          : Text(
                              '${controller.position.value?.latitude} : ${controller.position.value?.longitude}',
                              style: textTheme(context).bodyMedium),
                    ),
                  ),
                ),
                8.height,
                // Current Status Section
                Row(
                  children: [
                    Expanded(
                        child: Obx(
                      () => GSCardColumn(
                        children: [
                          Text("Jarak Dari Kantor".tr),
                          4.height,
                          Text(
                            "${decimalFormatter(controller.distance?.toInt(), defaultText: '?')} M",
                            style: textTheme(context).titleLarge?.copyWith(
                                  color: controller.distance != null &&
                                          controller.distance! <=
                                              controller.rules.distanceTolerance
                                      ? primaryColor(context)
                                      : colorScheme(context).error,
                                ),
                          ),
                        ],
                      ),
                    )),
                    16.width,
                    Expanded(
                        child: GSCardColumn(
                      children: [
                        Text("Status"),
                        4.height,
                        Obx(
                          () => Text(
                            controller.status,
                            style: textTheme(context).titleLarge?.copyWith(
                                  color: primaryColor(context),
                                ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
                // History Section
                Row(
                  children: [
                    Text("Riwayat Presensi".tr),
                    8.width,
                    Expanded(child: Divider(height: 48, thickness: 0.5)),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.PRESENSI_INDEX);
                      },
                      child: Text(
                        "Lihat semua".tr,
                        style: textTheme(context).labelMedium,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.presensi.length,
                    itemBuilder: (context, index) {
                      var data = controller.presensi[index];
                      return PresenceCard(data: data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor(context),
        onPressed: () {
          controller.presence(context);
        },
        child: Icon(
          Icons.fingerprint_rounded,
          size: 36,
          color: colorScheme(context).onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: GSBottomBar(),
    );
  }
}
