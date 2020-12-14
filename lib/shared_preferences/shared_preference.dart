import 'package:shared_preferences/shared_preferences.dart';
class SharedPre {
  static String sharedPreLanguageCode ="language_code";
  static String sharedPreCountryCode ="country_code";

  static String sharedPreIsLogin ="IS_LOGGED_IN";
  static String sharedPreUserName ="USER_NAME";
  static String sharedPreUserEmail="USER_EMAIL";

  static String sharedPreAccountType="USER_ACCOUNT_TYPE";
  static String sharedPreUSer="USER";

  static String sharedPreID ="id";
  static String sharedPreFullName ="fullName";
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
  static Future<bool> saveInt(String key,int value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(key, value);
  }

  static Future<bool> getBoolKey(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getBool(key);
  }

  static Future<String> getStringKey(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getString(key);
  }
  static Future<int> getIntKey(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getInt(key);
  }
  static Future<bool> clearKey(String key) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(key);
  }

  static Future<void> clearData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }


}