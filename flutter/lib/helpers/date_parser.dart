import 'package:intl/intl.dart';

class DateParser {
  static String getDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    DateFormat dateFormat = DateFormat('EEE, dd MMM');
    return dateFormat.format(date);
  }

  static String getDateTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    DateFormat dateFormat = DateFormat('EEE dd MMM - hh:mm a');
    return dateFormat.format(date);
  }
}
