import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils{
  String formatDate_dd_mm_yyy(DateTime dateTime){
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
String covertTimesnapToMilliseconds(DateTime dateTime){
  Timestamp myTimeStamp = Timestamp.fromDate(dateTime);
  return myTimeStamp.millisecondsSinceEpoch.toString();
}
String formatTimesnapToDate(int timesnap){
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timesnap);
  return formatDate_dd_mm_yyy(date);
}
}