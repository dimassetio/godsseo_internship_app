import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class GSDropdown extends StatelessWidget {
  GSDropdown({
    required this.listValue,
    required this.onChanged,
    this.valueAsTitle = true,
    this.isValidationRequired = true,
    this.isEnabled = true,
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
    this.titleFunction,
    this.suffixIcon,
    this.validator,
  });
  final List listValue;
  final bool valueAsTitle;
  final bool isValidationRequired;
  final bool isEnabled;
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
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final String Function(dynamic)? titleFunction;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: List.generate(
          listValue.length,
          (index) => DropdownMenuItem(
                value: listValue[index],
                child: Text(
                    "${valueAsTitle ? listValue[index] : titleFunction!(listValue[index])}"),
              )),
      onChanged: isEnabled ? onChanged : null,
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
      value: initValue,
      validator: validator ??
          (isValidationRequired
              ? (value) => value.isEmptyOrNull ? "This field is required" : null
              : null),
    );
  }
}
