import "package:flutter/material.dart";

import "package:get/get.dart";
import "package:godsseo/app/data/helpers/formatter.dart";
import "package:godsseo/app/data/helpers/themes.dart";
import "package:godsseo/app/data/widgets/card_column.dart";
import "package:godsseo/app/modules/home/views/presence_card.dart";
import "package:nb_utils/nb_utils.dart";

import "../controllers/presensi_index_controller.dart";

class PresensiIndexView extends GetView<PresensiIndexController> {
  const PresensiIndexView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Riwayat Presensi"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                // Card(
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(16)),
                //   margin: EdgeInsets.only(bottom: 16),
                //   color: primaryColor(context),
                //   child: Container(
                //     padding: EdgeInsets.all(16),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               controller.user.nama ?? "-",
                //               style: textTheme(context).titleMedium?.copyWith(
                //                   color: colorScheme(context).onPrimary),
                //             ),
                //             2.height,
                //             CircleContainer(
                //               color: colorScheme(context).secondary,
                //               padding: EdgeInsets.symmetric(
                //                   horizontal: 12, vertical: 2),
                //               child: Text(
                //                 controller.user.sekolah ?? "-",
                //                 style: textTheme(context).labelLarge?.copyWith(
                //                     color: colorScheme(context).onSecondary),
                //               ),
                //             ),
                //           ],
                //         ),
                //         CircleAvatar(child: Icon(Icons.person)),
                //       ],
                //     ),
                //   ),
                // ),
                GSCardColumn(
                  color: primaryColor(context),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rekap Presensi Bulanan".tr,
                          style: textTheme(context)
                              .bodyMedium
                              ?.copyWith(color: colorScheme(context).onPrimary),
                        ),
                        Obx(
                          () => TextButton.icon(
                            onPressed: () {
                              controller.pickMonth(context);
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: colorScheme(context).onPrimary,
                            ),
                            label: Text(
                              monthFormatter(controller.currentMonth),
                              style: textTheme(context).bodyMedium?.copyWith(
                                  color: colorScheme(context).onPrimary),
                            ),
                          ),
                        )
                      ],
                    ),
                    4.height,
                    Row(
                      children: [
                        Expanded(
                            child: GSCardColumn(
                          elevation: 0,
                          radius: 8,
                          padding: 8,
                          crossAxis: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Tepat Waktu".tr,
                                style: textTheme(context)
                                    .titleSmall
                                    ?.copyWith(color: primaryColor(context)),
                              ),
                            ),
                            Obx(
                              () => Text(
                                decimalFormatter(controller.countTepatWaktu),
                                style: textTheme(context)
                                    .titleLarge
                                    ?.copyWith(color: primaryColor(context)),
                              ),
                            ),
                          ],
                        )),
                        16.width,
                        Expanded(
                            child: GSCardColumn(
                          elevation: 0,
                          radius: 8,
                          padding: 8,
                          crossAxis: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Terlambat".tr,
                                style: textTheme(context)
                                    .titleSmall
                                    ?.copyWith(color: primaryColor(context)),
                              ),
                            ),
                            Obx(
                              () => Text(
                                decimalFormatter(controller.countTerlambat),
                                style: textTheme(context)
                                    .titleLarge
                                    ?.copyWith(color: primaryColor(context)),
                              ),
                            ),
                          ],
                        )),
                        16.width,
                        Expanded(
                            child: GSCardColumn(
                          elevation: 0,
                          radius: 8,
                          padding: 8,
                          crossAxis: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Absen".tr,
                                style: textTheme(context)
                                    .titleSmall
                                    ?.copyWith(color: primaryColor(context)),
                              ),
                            ),
                            Text(
                              decimalFormatter(0),
                              style: textTheme(context)
                                  .titleLarge
                                  ?.copyWith(color: primaryColor(context)),
                            ),
                          ],
                        )),
                      ],
                    )
                  ],
                ),
                Divider(height: 32, thickness: 0.5),
                Row(
                  children: [
                    Icon(Icons.timer, color: primaryColor(context)),
                    16.width,
                    Text("Riwayat Presensi".tr),
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
                      return PresenceCard(data: data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
