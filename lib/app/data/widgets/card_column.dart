import 'package:flutter/material.dart';
import 'package:godsseo/app/data/helpers/themes.dart';

class GSCardColumn extends StatelessWidget {
  GSCardColumn(
      {this.children = const [],
      this.padding = 16,
      this.margin,
      this.height,
      this.width,
      this.radius,
      this.elevation,
      this.color,
      this.crossAxis,
      this.onTap,
      this.mainAxis});
  final List<Widget> children;
  final double padding;
  final double? height;
  final double? width;
  final double? radius;
  final double? elevation;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment? mainAxis;
  final CrossAxisAlignment? crossAxis;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? EdgeInsets.zero,
      color: color ?? colorScheme(context).surface,
      elevation: elevation ?? 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius ?? 16),
        child: Container(
          height: height,
          alignment: Alignment.centerLeft,
          width: width,
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: crossAxis ?? CrossAxisAlignment.start,
            mainAxisAlignment: mainAxis ?? MainAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
