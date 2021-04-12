import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formattDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String formatDateFromTimestamp(Timestamp? timestamp) {
  return DateFormat.yMMMd().format(timestamp!.toDate());
}
