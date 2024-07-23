import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/languages.dart';
import 'package:intl/intl.dart';

String dateTimeFormatter(DateTime? date,
    {bool useSeparator = false, String? def}) {
  if (date is DateTime) {
    if (useSeparator) {
      return DateFormat('d MMM y | H.m', Get.locale?.countryCode).format(date);
    }
    return DateFormat('d MMM y H.m', Get.locale?.countryCode).format(date);
  } else
    return def ?? '';
}

String dateFormatter(DateTime? date, {bool withDays = false}) {
  if (date is DateTime) {
    String format = 'd MMM y';
    if (withDays) {
      format = 'EEE, d MMM y';
    }
    return DateFormat(format, Get.locale?.countryCode).format(date);
  } else
    return '';
}

String getDayName(int weekday) {
  const List<String> engWeekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  const List<String> idWeekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    "Jum'at",
    'Sabtu',
    'Minggu'
  ];

  List<String> weekdays() =>
      Get.locale == LanguageTranslation.localeID ? idWeekdays : engWeekdays;

  if (weekday < 1 || weekday > 7) {
    throw RangeError('Weekday must be between 1 and 7');
  }

  return weekdays()[weekday - 1];
}

String monthFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('MMMM y', Get.locale?.countryCode).format(date);
  } else
    return '';
}

String timeFormatter(DateTime? date,
    {bool withSecond = false, String defaultText = ''}) {
  if (date is DateTime) {
    String format = withSecond ? 'HH:mm:s' : 'HH:mm';
    return DateFormat(format, Get.locale?.countryCode).format(date);
  } else {
    return defaultText;
  }
}

int compareTime(TimeOfDay time1, TimeOfDay time2) {
  int vTime1 = (time1.hour * 60) + (time1.minute);
  int vTime2 = (time2.hour * 60) + (time2.minute);
  if (vTime1 < vTime2) {
    return -1;
  } else if (vTime1 > vTime2) {
    return 1;
  } else {
    return 0;
  }
}

DateTime? timeToDate(TimeOfDay? time) =>
    time != null ? DateTime(2024, 1, 1, time.hour, time.minute) : null;

TimeOfDay? dateToTime(DateTime? date) =>
    date != null ? TimeOfDay(hour: date.hour, minute: date.minute) : null;

GeoPoint posToGeo(Position pos) {
  return GeoPoint(pos.latitude, pos.longitude);
}

Position geoToPost(GeoPoint geo) {
  return Position.fromMap({
    'latitude': geo.latitude,
    'longitude': geo.longitude,
  });
}

DateTime toStartOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime toEndOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}

String decimalFormatter(int? amount,
    {String? locale, String? symbol, String? defaultText}) {
  if (amount == null && defaultText is String) {
    return defaultText;
  }
  final format = NumberFormat.decimalPattern("id_ID");
  return format.format(amount ?? 0);
}

Future<String> getAddress(double? lat, double? long,
    {String? defaultText}) async {
  if (lat == null || long == null) {
    return defaultText ?? '';
  }
  List<Placemark> places = await placemarkFromCoordinates(lat, long);
  Placemark? place = places.firstOrNull;
  if (place is Placemark) {
    return "${place.name ?? ''} ${place.street}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea} ";
  }
  return defaultText ?? '';
}

int countDaysInMonth(DateTime date) {
  int nextYear = date.month == 12 ? date.year + 1 : date.year;
  int nextMonth = date.month == 12 ? 1 : date.month + 1;
  DateTime firstDayOfNextMonth = DateTime(nextYear, nextMonth, 1);
  DateTime lastDayOfCurrentMonth =
      firstDayOfNextMonth.subtract(Duration(days: 1));
  return lastDayOfCurrentMonth.day;
}

DateTime getNextMonth(DateTime date) {
  int nextYear = date.month == 12 ? date.year + 1 : date.year;
  int nextMonth = date.month == 12 ? 1 : date.month + 1;
  return DateTime(nextYear, nextMonth, 1);
}

// int countActiveDays(DateTime date, {bool useDate = true}) {
//   return (useDate ? date.day : countDaysInMonth(date)) -
//       countSundayInMonth(date, useCurrentDate: useDate);
// }

// int countSundayInMonth(DateTime date, {bool useCurrentDate = false}) {
//   int days = useCurrentDate ? date.day : countDaysInMonth(date);
//   int sundayCount = 0;
//   for (int day = 1; day <= days; day++) {
//     DateTime newdate = DateTime(date.year, date.month, day);
//     if (newdate.weekday == DateTime.sunday) {
//       sundayCount++;
//     }
//   }
//   return sundayCount;
// }
