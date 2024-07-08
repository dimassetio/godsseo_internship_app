import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/circle_container.dart';
import 'package:nb_utils/nb_utils.dart';

class PresencePerformanceCard extends StatelessWidget {
  const PresencePerformanceCard({
    super.key,
    required this.data,
    required this.tepatWaktu,
    required this.terlambat,
    required this.absen,
    this.isLoading = false,
  });

  final UserModel data;
  final bool isLoading;
  final int tepatWaktu;
  final int terlambat;
  final int absen;

  @override
  Widget build(BuildContext context) {
    return GSCardColumn(
      onTap: () {
        // Get.toNamed(Routes.PRESENSI_DETAIL, arguments: data);
      },
      margin: EdgeInsets.only(bottom: 16),
      children: [
        Row(
          children: [
            Icon(Icons.person),
            8.width,
            Text(data.nickname ?? '-'),
            Expanded(child: SizedBox()),
            CircleContainer(
                color: primaryColor(context),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: Text(
                  data.sekolah ?? '-',
                  style: textTheme(context)
                      .labelLarge
                      ?.copyWith(color: colorScheme(context).onPrimary),
                )),
          ],
        ),
        6.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Tepat Waktu'.tr,
                  style: textTheme(context).labelMedium,
                ),
                4.height,
                isLoading
                    ? SizedBox(width: 32, child: LinearProgressIndicator())
                    : Text(
                        decimalFormatter(tepatWaktu),
                        style: textTheme(context)
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Terlambat'.tr,
                  style: textTheme(context).labelMedium,
                ),
                4.height,
                isLoading
                    ? SizedBox(width: 32, child: LinearProgressIndicator())
                    : Text(
                        decimalFormatter(terlambat),
                        style: textTheme(context)
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Absen'.tr,
                  style: textTheme(context).labelMedium,
                ),
                4.height,
                isLoading
                    ? SizedBox(width: 32, child: LinearProgressIndicator())
                    : Text(
                        decimalFormatter(absen),
                        style: textTheme(context)
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
