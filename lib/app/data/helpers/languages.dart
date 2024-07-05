import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Word extends Translations {
  static const Locale localeID = Locale("id", "ID");
  static const Locale localeEN = Locale("en", "US");
  static const List<Locale> localeList = [localeEN, localeID];

  @override
  Map<String, Map<String, String>> get keys =>
      {'en_US': english, 'id_ID': indonesia};
}

Map<String, String> indonesia = {};

Map<String, String> english = {};
