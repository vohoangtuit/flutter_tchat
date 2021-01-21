import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tchat_app/models/last_message_model.dart';

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
bool lastMessageProfileEmpty(LastMessageModel lastMessageModel){
    return lastMessageModel?.photoReceiver?.isEmpty??true;
}
}