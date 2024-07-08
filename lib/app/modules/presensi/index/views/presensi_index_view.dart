import "package:flutter/material.dart";

import "package:get/get.dart";
import "package:godsseo/app/data/helpers/themes.dart";
import "package:godsseo/app/modules/home/views/presence_card.dart";
import "package:godsseo/app/modules/presensi/index/views/monthly_recap.dart";
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
                Obx(
                  () => MonthlyPresenceRecap(
                    pickMonth: () {
                      controller.pickMonth(context);
                    },
                    currentMonth: controller.currentMonth,
                    countTepatWaktu: controller.countTepatWaktu,
                    countTerlambat: controller.countTerlambat,
                    countAbsen: controller.countAbsen,
                  ),
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
