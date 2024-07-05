import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/routes/app_pages.dart';

class PresenceCard extends StatelessWidget {
  const PresenceCard({
    super.key,
    required this.data,
  });

  final PresensiModel data;

  @override
  Widget build(BuildContext context) {
    return GSCardColumn(
      onTap: () {
        Get.toNamed(Routes.PRESENSI_DETAIL, arguments: data);
      },
      margin: EdgeInsets.only(bottom: 16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'masuk'.tr,
                  style: textTheme(context).labelMedium,
                ),
                Text(timeFormatter(
                  data.dateIn,
                )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'keluar'.tr,
                  style: textTheme(context).labelMedium,
                ),
                Text(
                  timeFormatter(data.dateOut, defaultText: '-- : --'),
                ),
              ],
            ),
            Text(
              dateFormatter(data.dateIn, withDays: true),
            ),
          ],
        ),
      ],
    );
  }
}
