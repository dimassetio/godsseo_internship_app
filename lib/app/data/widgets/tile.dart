import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:nb_utils/nb_utils.dart';

class GSTile extends StatelessWidget {
  const GSTile({
    super.key,
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
    this.leading,
    this.trailing,
    this.verticalAlignment = CrossAxisAlignment.center,
    this.horizontalAlignment = MainAxisAlignment.start,
  });
  final String label;
  final TextStyle? labelStyle;
  final String value;
  final TextStyle? valueStyle;
  final Widget? leading;
  final Widget? trailing;
  final CrossAxisAlignment verticalAlignment;
  final MainAxisAlignment horizontalAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: horizontalAlignment,
        crossAxisAlignment: verticalAlignment,
        children: [
          if (leading is Widget) leading!.marginOnly(right: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: labelStyle ??
                      textTheme(context)
                          .labelMedium
                          ?.copyWith(color: textColorSecondary),
                ),
                2.height,
                Text(
                  value,
                  style: valueStyle ?? textTheme(context).bodyMedium,
                ),
              ],
            ),
          ),
          if (trailing is Widget) trailing!.marginOnly(left: 12),
        ],
      ),
    );
  }
}
