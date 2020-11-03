import 'package:shared_preferences/shared_preferences.dart';
class SharedPre {
  static String sharedPreIsLogin ="IS_LOGGED_IN";
  static String sharedPreUserName ="USER_NAME";
  static String sharedPreUserEmail="USER_EMAIL";

  static String sharedPreID ="id";
  static String sharedPreNickname ="nickname";
  static String sharedPrePhotoUrl ="photoUrl";
  static String sharedPreAboutMe ="aboutMe";

  static Future<bool> saveBool(String key,bool value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(key, value);
  }
  static Future<bool> saveString(String key,String value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(key, value);
  }

  static Future<bool> getBoolKey(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getBool(key);
  }

  static Future<String> getStringKey(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(key);
  }

  static Future<void> clearData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}