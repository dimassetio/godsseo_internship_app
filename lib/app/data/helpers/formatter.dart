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

String dateFormatter(DateTime? date) {
  if (date is DateTime) {
    return DateFormat('d MMM y').format(date);
  } else
    return '';
}
