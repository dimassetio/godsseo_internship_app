import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/modules/presensi/admin/views/presence_performances_card.dart';
import 'package:godsseo/app/modules/presensi/index/views/monthly_recap.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/presensi_admin_controller.dart';

class PresensiAdminView extends GetView<PresensiAdminController> {
  const PresensiAdminView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Rekap Presensi'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Obx(
                  () => MonthlyPresenceRecap(
                    pickMonth: () {},
                    currentMonth: DateTime.now(),
                    countTepatWaktu: controller.countTepatWaktu,
                    countTerlambat: controller.countTerlambat,
                    countAbsen: controller.countAbsen,
                  ),
                ),
                Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.ssid_chart,
                          color: primaryColor(context),
                        ),
                        4.width,
                        Text("Performa Presensi".tr),
                      ],
                    ),
                    // Button Laporan
                  ],
                ),
                16.height,
                FutureBuilder<List<UserModel>>(
                  future: controller.getUsers(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? LinearProgressIndicator()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (context, index) {
                                UserModel user = snapshot.data![index];
                                return FutureBuilder<Performance?>(
                                  future: controller.getPerformances(user),
                                  builder: (context, snapshot) =>
                                      PresencePerformanceCard(
                                    data: user,
                                    isLoading: snapshot.connectionState ==
                                        ConnectionState.waiting,
                                    absen: snapshot.data?.absen ?? 99,
                                    tepatWaktu: snapshot.data?.masuk ?? 99,
                                    terlambat: snapshot.data?.terlambat ?? 99,
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ));
  }
}
