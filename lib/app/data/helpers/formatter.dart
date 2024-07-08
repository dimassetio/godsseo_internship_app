import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

String dateTimeFormatter(DateTime? date,
    {bool useSeparator = false, String? def}) {
  if (date is DateTime) {
    if (useSeparator) {
      return DateFormat('d MMM y | H.m').format(date);
    }
    return DateFormat('d MMM y H.m').format(date);
    // return "${DateFormat.yMMMMd('id').format(date)} ${DateFormat.Hm('id').format(date)}";
  } else
    return def ?? '';
}

String dateFormatter(DateTime? date, {bool withDays = false}) {
  if (date is DateTime) {
    String format = 'd MMM y';
    if (withDays) {
      format = 'EEE, d MMM y';
    }
    return DateFormat(format).format(date);
  } else
    return '';
}

String monthFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('MMMM y').format(date);
  } else
    return '';
}

String timeFormatter(DateTime? date,
    {bool withSecond = false, String defaultText = ''}) {
  if (date is DateTime) {
    String format = withSecond ? 'H:m:s' : 'H:m';
    return DateFormat(format).format(date);
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

int countActiveDays(DateTime date) {
  return date.day - countSundayInMonth(date, useCurrentDate: true);
}

int countSundayInMonth(DateTime date, {bool useCurrentDate = false}) {
  int days = useCurrentDate ? date.day : countDaysInMonth(date);
  int sundayCount = 0;
  for (int day = 1; day <= days; day++) {
    DateTime newdate = DateTime(date.year, date.month, day);
    if (newdate.weekday == DateTime.sunday) {
      sundayCount++;
    }
  }
  return sundayCount;
}
