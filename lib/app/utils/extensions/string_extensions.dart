import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

extension StringX on String {
  // Validations
  bool get isPhoneValid => length <= 15 && length >= 3;
  bool get isEmailValid =>
      RegExp(r'^\s*[\w-\.]+@([\w-]+\.)+[\w-]{2,4}\s*$').hasMatch(this);
  bool get isArabicOnly => RegExp(r'^[\u0600-\u06FF\s]*$').hasMatch(this);
  bool get isEnglishOnly => RegExp(r'^[a-zA-Z\s]*$').hasMatch(this);

  String get toArabicOnly => replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');
  String get toEnglishOnly => replaceAll(RegExp(r'[^a-zA-Z\s]'), '');

  String get keyLocalization =>
      toLowerCase().replaceAll(" ", "_").replaceAll(".", "");
  String get removeTrailingZero =>
      contains('.') && !endsWith('0') ? this : replaceAll(RegExp(r'\.0+$'), '');

  // URL / Call / Email
  Future<void> get launchUrl async {
    final Uri uri = Uri.parse(this);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(
        uri,
        mode: launcher.LaunchMode.externalApplication,
      );
    }
  }

  Future<void> get launchCall async {
    final Uri uri = Uri(scheme: 'tel', path: this);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(
        uri,
        mode: launcher.LaunchMode.externalApplication,
      );
    }
  }

  Future<void> get launchEmail async {
    final Uri uri = Uri(scheme: 'mailto', path: this);
    if (await launcher.canLaunchUrl(uri)) {
      await launcher.launchUrl(
        uri,
        mode: launcher.LaunchMode.externalApplication,
      );
    }
  }

  // Date & Time
  DateTime? get toDateTime => DateTime.tryParse(this);

  String formatYMMMMd(String localeCode) {
    final date = DateTime.tryParse(this);
    if (date == null) return this;

    return DateFormat.yMMMMd(localeCode).format(date).replaceArabicNumerals;
  }

  String formatTime12h(String localeCode) {
    DateTime? date;
    date = DateTime.tryParse(this);
    date ??= DateFormat("HH:mm").tryParse(this, true);
    if (date == null) return "";

    return DateFormat("hh:mm a", localeCode).format(date).replaceArabicNumerals;
  }

  String get replaceArabicNumerals {
    return replaceAllMapped(RegExp(r'[٠-٩]'), (match) {
      const map = {
        '٠': '0',
        '١': '1',
        '٢': '2',
        '٣': '3',
        '٤': '4',
        '٥': '5',
        '٦': '6',
        '٧': '7',
        '٨': '8',
        '٩': '9',
      };
      return map[match[0]]!;
    });
  }
}
