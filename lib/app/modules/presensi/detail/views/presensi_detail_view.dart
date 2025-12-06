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

  // Helper untuk mendapatkan warna status (merah/hijau/abu)
  Color StatusColor(String? status) {
    if (status == 'Tepat Waktu') return Colors.green;
    if (status == 'Terlambat') return Colors.red;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan data presensi sudah dimuat (gunakan Obx untuk reaktif)
    return Obx(() {
      final presensiData = controller.presensi.value;
      
      // Ambil waktu batas piket dengan safety check
      final String limitTime = controller.rules.value != null 
                               ? controller.applicableLimitTime 
                               : '--:--';
      
      return Scaffold(
        appBar: AppBar(
          title: Text("Detail Presensi".tr),
          centerTitle: true,
        ),
        body: presensiData == null
            ? Center(
                child: Text("Gagal memuat data presensi".tr),
              )
            : SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // --- KARTU INFO PIKET ---
                      if (presensiData.isPiket)
                        GSCardColumn(
                          color: Colors.amber,
                          padding: 16,
                          margin: const EdgeInsets.only(bottom: 16),
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.cleaning_services, color: Colors.black87),
                                8.width,
                                Text("Presensi Piket Aktif!".tr, style: textTheme(context).titleMedium?.copyWith(color: Colors.black87)),
                              ],
                            ),
                            4.height,
                            Text(
                              presensiData.statusIn == 'Terlambat'
                                // FIX: Menggunakan variabel limitTime yang sudah dicek null
                                ? "Terlambat dihitung dari jam batas piket ($limitTime)"
                                : "Jam batas masuk Anda hari ini adalah $limitTime",
                              style: textTheme(context).bodySmall?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),
                      // --- END KARTU PIKET ---
                      
                      // --- CARD MASUK ---
                      GSCardColumn(
                        color: primaryColor(context),
                        children: [
                          GSTile(
                            label: "Masuk".tr,
                            value: timeFormatter(presensiData.dateIn),
                            labelStyle: textTheme(context)
                                .labelMedium
                                ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                            valueStyle: textTheme(context)
                                .titleLarge
                                ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                            trailing: Text(
                              dateFormatter(presensiData.dateIn),
                              style: textTheme(context).bodyMedium?.copyWith(
                                    color: Colors.white, // FIX: Diganti Colors.white
                                  ),
                            ),
                          ),
                          
                          // --- STATUS IN ---
                          GSTile(
                            label: "Status".tr,
                            value: presensiData.statusIn ?? '',
                            labelStyle: textTheme(context)
                                .labelMedium
                                ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                            valueStyle: textTheme(context)
                                .bodyMedium
                                // FIX: Ubah ke warna kontras (Putih)
                                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold), 
                          ),

                          // --- LOKASI MASUK ---
                          FutureBuilder<String>(
                            // Asumsi getAddress adalah helper global untuk geocoding
                            future: getAddress(
                                presensiData.coordinateIn?.latitude,
                                presensiData.coordinateIn?.longitude,
                                defaultText: '--'),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return LinearProgressIndicator();
                              }
                              return GSTile(
                                label: "Lokasi Masuk".tr,
                                value: snapshot.data ?? '--',
                                labelStyle: textTheme(context)
                                    .labelMedium
                                    ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                                valueStyle: textTheme(context)
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                              );
                            }),
                          GSTile(
                            label: "Jarak dari kantor".tr,
                            value:
                                "${decimalFormatter(presensiData.distanceIn, defaultText: '-')} M",
                            labelStyle: textTheme(context)
                                .labelMedium
                                ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                            valueStyle: textTheme(context)
                                .bodyMedium
                                ?.copyWith(color: Colors.white), // FIX: Diganti Colors.white
                          ),
                        ],
                      ),
                      16.height,
                      // --- CARD KELUAR ---
                      GSCardColumn(
                        children: [
                          GSTile(
                            label: "Keluar".tr,
                            value: timeFormatter(presensiData.dateOut,
                                defaultText: "-"),
                            valueStyle: textTheme(context).titleLarge,
                            trailing: Text(
                              dateFormatter(presensiData.dateOut),
                            ),
                          ),
                          GSTile(
                            label: "Status Keluar".tr,
                            value: presensiData.statusOut ?? "-",
                          ),
                          // --- LOKASI KELUAR ---
                          FutureBuilder<String>(
                              future: getAddress(
                                  presensiData.coordinateOut?.latitude,
                                  presensiData.coordinateOut?.longitude,
                                  defaultText: "-"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return LinearProgressIndicator();
                                }
                                return GSTile(
                                  label: "Lokasi Keluar".tr,
                                  value: snapshot.data ?? "-",
                                );
                              }),
                          GSTile(
                            label: "Jarak dari kantor".tr,
                            value:
                                "${decimalFormatter(presensiData.distanceOut, defaultText: '-')} M",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
        );
    });    
  }
}