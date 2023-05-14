import 'package:intl/intl.dart';

class FormatDate {
  static String formatDateView(DateTime time) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(time);
    return formattedDate;
  }

  static String formatDateInsertDB(DateTime time) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(time);
    return formattedDate;
  }

  static String formatDateInsertDBHHss(DateTime time) {
    String formattedDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(time);
    return formattedDate;
  }

  static String formatDateddMMyy(DateTime time) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(time);
    return formattedDate;
  }

  static String formatTime(DateTime time) {
    String formattedTime = DateFormat('HH:mm').format(time);
    return formattedTime;
  }

  static String formatTimeViewYyyyMmDd(DateTime time) {
    String formattedTime = DateFormat('yyyy-MM-dd').format(time);
    return formattedTime;
  }

  // a thêm a để hiện am và pm
  static String formatDateDayHours(DateTime time) {
    String formattedDate = DateFormat('HH:mm a dd-MM-yyyy').format(time);
    return formattedDate;
  }
}
