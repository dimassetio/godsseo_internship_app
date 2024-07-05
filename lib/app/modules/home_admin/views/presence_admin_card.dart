import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/presensi_model.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/data/widgets/card_column.dart';
import 'package:godsseo/app/data/widgets/circle_container.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

class PresenceAdminCard extends StatelessWidget {
  const PresenceAdminCard({
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
        FutureBuilder<UserModel?>(
          future: data.getUser(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? LinearProgressIndicator()
              : Row(
                  children: [
                    Icon(Icons.person),
                    8.width,
                    Text(snapshot.data?.nickname ?? '-'),
                    Expanded(child: SizedBox()),
                    CircleContainer(
                        color: primaryColor(context),
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        child: Text(
                          snapshot.data?.sekolah ?? '-',
                          style: textTheme(context)
                              .labelLarge
                              ?.copyWith(color: colorScheme(context).onPrimary),
                        )),
                  ],
                ),
        ),
        6.height,
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
