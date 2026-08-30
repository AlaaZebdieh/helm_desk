// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'string_extensions.dart';

extension DateTimeX on DateTime {
  bool isSameDate(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  String get formattedYMD =>
      DateFormat('yyyy-MM-dd').format(this).replaceArabicNumerals;

  String get formattedDateTime {
    return DateFormat("yyyy-MM-dd | hh:mm a")
        .format(this)
        .replaceArabicNumerals;
  }

  String get formattedTime_hhmm_a =>
      DateFormat("hh:mm a").format(this).replaceArabicNumerals;
}
