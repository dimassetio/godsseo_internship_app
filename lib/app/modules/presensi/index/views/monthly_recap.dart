import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:nb_utils/nb_utils.dart';

class MonthlyPresenceRecap extends StatelessWidget {
  const MonthlyPresenceRecap({
    super.key,
    required this.pickMonth,
    required this.currentMonth,
    required this.countTepatWaktu,
    required this.countTerlambat,
    required this.countAbsen,
  });

  final void Function()? pickMonth;
  final DateTime currentMonth;
  final int countTepatWaktu;
  final int countTerlambat;
  final int countAbsen;

  @override
  Widget build(BuildContext context) {
    return GSCardColumn(
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
            TextButton.icon(
              onPressed: pickMonth,
              icon: Icon(
                Icons.calendar_month,
                color: colorScheme(context).onPrimary,
              ),
              label: Text(
                monthFormatter(currentMonth),
                style: textTheme(context)
                    .bodyMedium
                    ?.copyWith(color: colorScheme(context).onPrimary),
              ),
            ),
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
                Text(
                  decimalFormatter(countTepatWaktu),
                  style: textTheme(context)
                      .titleLarge
                      ?.copyWith(color: primaryColor(context)),
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
                Text(
                  decimalFormatter(countTerlambat),
                  style: textTheme(context)
                      .titleLarge
                      ?.copyWith(color: primaryColor(context)),
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
                  decimalFormatter(countAbsen),
                  style: textTheme(context)
                      .titleLarge
                      ?.copyWith(color: primaryColor(context)),
                ),
              ],
            )),
          ],
        )
      ],
    );
  }
}
