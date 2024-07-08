import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/circle_container.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:godsseo/app/modules/home_admin/views/presence_admin_card.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/home_admin_controller.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  const HomeAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Obx(
                  () => ListTile(
                    title: Text(
                      "Halo,".trParams(
                          {'name': authC.user.nickname ?? "{username}"}),
                      style: textTheme(context)
                          .titleLarge
                          ?.copyWith(color: primaryColor(context)),
                    ),
                    subtitle: Row(
                      children: [
                        CircleContainer(
                          margin: EdgeInsets.only(top: 4),
                          color: colorScheme(context).secondary,
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          child: Text(
                            "${authC.user.role}",
                            style: textTheme(context).labelLarge?.copyWith(
                                color: colorScheme(context).onPrimary),
                          ),
                        ),
                      ],
                    ),
                    trailing: CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
                Divider(height: 32),
                GSCardColumn(
                  color: primaryColor(context),
                  children: [
                    Text(
                      "Presensi Hari Ini",
                      style: textTheme(context)
                          .titleSmall
                          ?.copyWith(color: colorScheme(context).onPrimary),
                    ),
                    12.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 20,
                                color: colorScheme(context).onPrimary),
                            4.width,
                            Text(
                              dateFormatter(
                                DateTime.now(),
                              ),
                              style: textTheme(context).bodyMedium?.copyWith(
                                  color: colorScheme(context).onPrimary),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 20,
                              color: colorScheme(context).onPrimary,
                            ),
                            4.width,
                            Text(
                              timeFormatter(DateTime.now()),
                              style: textTheme(context).bodyMedium?.copyWith(
                                  color: colorScheme(context).onPrimary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    12.height,
                    Obx(
                      () => Row(
                        children: [
                          Expanded(
                            child: GSCardColumn(
                              elevation: 0,
                              crossAxis: CrossAxisAlignment.center,
                              children: [
                                Center(child: Text("Masuk".tr)),
                                4.height,
                                Text(
                                  decimalFormatter(controller.countMasuk),
                                  style: textTheme(context)
                                      .titleLarge
                                      ?.copyWith(
                                          color: primaryColor(context),
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: GSCardColumn(
                              elevation: 0,
                              crossAxis: CrossAxisAlignment.center,
                              children: [
                                Center(child: Text("Terlambat".tr)),
                                4.height,
                                Text(
                                  decimalFormatter(controller.countTerlambat),
                                  style: textTheme(context)
                                      .titleLarge
                                      ?.copyWith(
                                          color: primaryColor(context),
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: GSCardColumn(
                              elevation: 0,
                              crossAxis: CrossAxisAlignment.center,
                              children: [
                                Center(child: Text("Belum".tr)),
                                4.height,
                                controller.isLoading
                                    ? LinearProgressIndicator()
                                    : Text(
                                        decimalFormatter(controller.countBelum),
                                        style: textTheme(context)
                                            .titleLarge
                                            ?.copyWith(
                                                color: primaryColor(context),
                                                fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Divider(height: 32),
                Row(
                  children: [
                    Icon(Icons.timer, color: primaryColor(context)),
                    4.width,
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
                16.height,
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.presensi.length,
                    itemBuilder: (context, index) {
                      var data = controller.presensi[index];
                      return PresenceAdminCard(data: data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GSBottomNavBar(
        currentIndex: 0,
      ),
    );
  }
}
