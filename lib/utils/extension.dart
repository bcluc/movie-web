import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toVnFormat() {
    return '${day.twoDigits()}/${month.twoDigits()}/${year.twoDigits()}';
  }
}

extension IntExtension on int {
  String toVnCurrencyFormat() {
    return NumberFormat.currency(locale: 'vi_VN').format(this);
  }

  String toVnCurrencyWithoutSymbolFormat() {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '').format(this).trim();
  }

  String twoDigits() {
    if (this >= 10) return "$this";
    return "0$this";
  }
}

String formatBytes(int bytes) {
  const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
  int i = 0;
  double fileSize = bytes.toDouble();

  while (fileSize >= 1024 && i < sizes.length - 1) {
    fileSize /= 1024;
    i++;
  }

  return '${fileSize.toInt()} ${sizes[i]}';
}
