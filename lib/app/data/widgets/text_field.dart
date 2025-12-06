import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class GSTextField extends StatelessWidget {
  GSTextField({
    this.textFieldType = TextFieldType.NAME,
    this.controller,
    this.isValidationRequired = true,
    this.isEnabled,
    this.isReadOnly = false,
    this.digitsOnly,
    this.icon,
    this.isBordered = false,
    this.label,
    this.initValue,
    this.hint,
    this.suffixColor,
    this.maxLine,
    this.borderRadius,
    this.inputFormatters,
    this.suffixIcon,
    this.validator,
    this.onTap,
  });
  final TextFieldType textFieldType;
  final TextEditingController? controller;
  final bool isValidationRequired;
  final bool? isEnabled;
  final bool isReadOnly;
  final bool? digitsOnly;
  final Icon? icon;
  final bool isBordered;
  final String? label;
  final String? initValue;
  final String? hint;
  final Color? suffixColor;
  final int? maxLine;
  final double? borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      onTap: onTap,
      controller: controller,
      isValidationRequired: isValidationRequired,
      maxLines: maxLine,
      inputFormatters: inputFormatters ??
          ((digitsOnly ?? false)
              ? [FilteringTextInputFormatter.digitsOnly]
              : null),
      textFieldType: textFieldType,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIcon: icon,
        border: isBordered
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 100))
            : null,
        labelText: label,
        hintText: hint,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixColor,
      ),
      enabled: isEnabled,
      readOnly: isReadOnly,
      validator: validator,
      initialValue: initValue,
    );
  }
}
