
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:timeago/timeago.dart' as timeago;
class TimeAgo {
  var locale ='vi';// es
 // SharedPre.getStringKey(SharedPre.sharedPreLanguageCode).timeago
  String timeAgo(String languageCode,DateTime date) {
    //print('languageCode '+languageCode);
    return timeago.format(date, locale: languageCode, allowFromNow: true);
  }
  DateTime getDateTimeFromString(String dateTime){
   // var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTime) * 1000);
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTime));
    return date;
  }
 String getLanguageCode(){
    String languageCode='vi';// default
     SharedPre.getStringKey(SharedPre.sharedPreLanguageCode).then((value){
       languageCode =value;
       print('languageCode '+languageCode);
       return languageCode;
    });
    return languageCode;
  }
}