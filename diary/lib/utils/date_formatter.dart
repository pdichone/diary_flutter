import 'package:intl/intl.dart';

String formattDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}
