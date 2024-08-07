import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/tile.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/presensi_detail_controller.dart';

class PresensiDetailView extends GetView<PresensiDetailController> {
  const PresensiDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Presensi".tr),
        centerTitle: true,
      ),
      body: controller.presensi == null
          ? Center(
              child: Text("Gagal memuat data presensi".tr),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    GSCardColumn(
                      color: primaryColor(context),
                      children: [
                        GSTile(
                          label: "Masuk".tr,
                          value: timeFormatter(controller.presensi!.dateIn),
                          labelStyle: textTheme(context)
                              .labelMedium
                              ?.copyWith(color: colorScheme(context).onPrimary),
                          valueStyle: textTheme(context)
                              .titleLarge
                              ?.copyWith(color: colorScheme(context).onPrimary),
                          trailing: Text(
                            dateFormatter(controller.presensi!.dateIn),
                            style: textTheme(context).bodyMedium?.copyWith(
                                  color: colorScheme(context).onPrimary,
                                ),
                          ),
                        ),
                        GSTile(
                          label: "Status".tr,
                          value: controller.presensi!.statusIn ?? '',
                          labelStyle: textTheme(context)
                              .labelMedium
                              ?.copyWith(color: colorScheme(context).onPrimary),
                          valueStyle: textTheme(context)
                              .bodyMedium
                              ?.copyWith(color: colorScheme(context).onPrimary),
                        ),
                        FutureBuilder<String>(
                            future: getAddress(
                                controller.presensi!.coordinateIn?.latitude,
                                controller.presensi!.coordinateIn?.longitude,
                                defaultText: '--'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LinearProgressIndicator();
                              }
                              return GSTile(
                                label: "Lokasi".tr,
                                value: snapshot.data ?? '--',
                                labelStyle: textTheme(context)
                                    .labelMedium
                                    ?.copyWith(
                                        color: colorScheme(context).onPrimary),
                                valueStyle: textTheme(context)
                                    .bodyMedium
                                    ?.copyWith(
                                        color: colorScheme(context).onPrimary),
                              );
                            }),
                        GSTile(
                          label: "Jarak dari kantor",
                          value:
                              "${decimalFormatter(controller.presensi!.distanceIn, defaultText: '-')} M",
                          labelStyle: textTheme(context)
                              .labelMedium
                              ?.copyWith(color: colorScheme(context).onPrimary),
                          valueStyle: textTheme(context)
                              .bodyMedium
                              ?.copyWith(color: colorScheme(context).onPrimary),
                        ),
                      ],
                    ),
                    16.height,
                    GSCardColumn(
                      children: [
                        GSTile(
                          label: "Keluar".tr,
                          value: timeFormatter(controller.presensi!.dateOut,
                              defaultText: "-"),
                          valueStyle: textTheme(context).titleLarge,
                          trailing: Text(
                            dateFormatter(controller.presensi!.dateOut),
                          ),
                        ),
                        GSTile(
                          label: "Status".tr,
                          value: controller.presensi!.statusOut ?? "-",
                        ),
                        FutureBuilder<String>(
                            future: getAddress(
                                controller.presensi!.coordinateOut?.latitude,
                                controller.presensi!.coordinateOut?.longitude,
                                defaultText: "-"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return LinearProgressIndicator();
                              }
                              return GSTile(
                                label: "Lokasi".tr,
                                value: snapshot.data ?? "-",
                              );
                            }),
                        GSTile(
                          label: "Jarak dari kantor".tr,
                          value:
                              "${decimalFormatter(controller.presensi!.distanceOut, defaultText: '-')} M",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
