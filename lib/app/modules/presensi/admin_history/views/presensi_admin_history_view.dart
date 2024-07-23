import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/modules/presensi/admin_history/views/presence_admin_card.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/presensi_admin_history_controller.dart';

class PresensiAdminHistoryView extends GetView<PresensiAdminHistoryController> {
  const PresensiAdminHistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Riwayat Presensi Admin".tr),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                    margin: EdgeInsets.zero,
                    color: primaryColor(context),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Riwayat Presensi Bulanan".tr,
                            style: textTheme(context).bodyMedium?.copyWith(
                                color: colorScheme(context).onPrimary),
                          ),
                          Obx(
                            () => TextButton.icon(
                              onPressed: () => controller.pickMonth(context),
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
                          ),
                        ],
                      ),
                    )),
                16.height,
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: controller.presensi.length,
                    itemBuilder: (context, index) {
                      var data = controller.presensi[index];
                      if (index > 0 &&
                          toStartOfDay(data.dateIn!) ==
                              toStartOfDay(
                                  controller.presensi[index - 1].dateIn!)) {
                        return PresenceAdminCard(data: data);
                      } else {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                  height: 32,
                                )),
                                16.width,
                                Text(
                                  dateFormatter(data.dateIn),
                                  style: textTheme(context).labelMedium,
                                ),
                                16.width,
                                Expanded(child: Divider()),
                              ],
                            ),
                            PresenceAdminCard(data: data),
                          ],
                        );
                      }
                    },
                  ),
                ),
                16.height,
                Obx(() => controller.showAll
                    ? SizedBox()
                    : Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              controller.showAll = true;
                            },
                            child: Text("Show All")),
                      ))
              ],
            ),
          ),
        ));
  }
}
