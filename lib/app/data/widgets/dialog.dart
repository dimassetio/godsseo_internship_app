import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/assets.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:nb_utils/nb_utils.dart';

class GSDialog extends StatelessWidget {
  GSDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.svgIllustration,
    this.image,
    this.confirmText,
    this.negativeText,
    this.onConfirm,
    this.onNegative,
  });
  final String title;
  final String subtitle;
  final String? svgIllustration;
  final String? image;
  final String? confirmText;
  final String? negativeText;
  final void Function()? onConfirm;
  final void Function()? onNegative;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            image is String
                ? Image.asset(image!)
                : SvgPicture.asset(svgIllustration ?? svg_confirmation),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme(context)
                  .titleMedium
                  ?.copyWith(color: primaryColor(context)),
            ),
            8.height,
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (negativeText is String)
                  ElevatedButton(
                    onPressed: onNegative ??
                        () {
                          Get.back(closeOverlays: true);
                        },
                    child: Text(negativeText ?? "No"),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: colorScheme(context).surface,
                        foregroundColor: primaryColor(context),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: primaryColor(context)),
                            borderRadius: BorderRadius.circular(24))),
                  ).marginOnly(right: 16),
                ElevatedButton(
                  onPressed: onConfirm ??
                      () {
                        Get.back(closeOverlays: true);
                      },
                  child: Text(confirmText ?? "Ok"),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
