import 'dart:ui';

import 'package:haivn/common/btn_thang_nam.dart';
import 'package:intl/intl.dart';

bool isNumeric(String str) {
  bool status = false;
  try {
    int.parse(str);
    status = true;
    return status;
  } catch (e) {
    status = false;
    return status;
  }
}

String getDay(time) {
  return DateFormat('dd').format(DateTime.parse(time).toLocal());
}

String getMonth(time) {
  return DateFormat('MM').format(DateTime.parse(time).toLocal());
}

String getYear(time) {
  return DateFormat('yyyy').format(DateTime.parse(time).toLocal());
}

String getTime(time) {
  return DateFormat('dd-MM-yyyy').format(DateTime.parse(time).toLocal());
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
