//---------todo UserModel------------
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

final String USER_MODEL = 'UserModel';
final String USER_ID = 'id';
final String USER_IDDB = 'idDB';
final String USER_USERNAME = 'userName';
final String USER_FULLNAME = 'fullName';
final String USER_EMAIL = 'email';
final String USER_PHOTO_URL = 'photoURL';
final String USER_PHONE = 'phoneNumber';
final String USER_BIRTHDAY = 'birthday';
final String USER_GENDER = 'gender';
final String USER_CREATED_AT = 'createdAt';
final String USER_LAST_UPDATED = 'lastUpdated';
final String USER_STATUS_ACCOUNT = 'statusAccount';
final String USER_PUST_TOKEN = 'pushToken';
final String USER_ISlOGIN = 'isLogin';
final String USER_ACCOUNT_TYPE = 'accountType';
final String USER_ALLOW_SEARCH = 'allowSearch';
final String USER_COVER = 'cover';
final String USER_LOCATION_LAT = 'latitude';
final String USER_LOCATION_LONG = 'longitude';
//
final int USER_ACCOUNT_FACEBOOK = 1;
final int USER_ACCOUNT_GMAIL = 2;
final int USER_ACCOUNT_PHONE = 3;
final int USER_ACCOUNT_EMAIL = 4;

@entity
class UserModel {
  @PrimaryKey(autoGenerate: true)
  int idDB;
  String id = '';
  String userName = '';
  String fullName = '';
  String birthday = '';
  int gender = 0;
  String email = '';
  String photoURL = '';
  String cover = '';
  int statusAccount = 0;
  String phoneNumber = '';
  String createdAt = '';
  String lastUpdated = '';
  String pushToken = '';
  bool isLogin;
  int accountType = 0;
  bool allowSearch = true;
  double latitude = 0.0;
  double longitude = 0.0;

  UserModel(
      {this.idDB,
      this.id,
      this.userName,
      this.fullName,
      this.birthday,
      this.gender,
      this.email,
      this.photoURL,
      this.cover,
      this.statusAccount,
      this.phoneNumber,
      this.createdAt,
      this.lastUpdated,
      this.pushToken,
      this.isLogin,
      this.accountType,
      this.allowSearch,
      this.latitude,
      this.longitude});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[USER_ID] = this.id;
    data[USER_USERNAME] = this.userName;
    data[USER_FULLNAME] = this.fullName;
    data[USER_BIRTHDAY] = this.birthday;
    data[USER_GENDER] = this.gender;
    data[USER_EMAIL] = this.email;
    data[USER_PHOTO_URL] = this.photoURL;
    data[USER_COVER] = this.cover;
    data[USER_STATUS_ACCOUNT] = this.statusAccount;
    data[USER_PHONE] = this.phoneNumber;
    data[USER_CREATED_AT] = this.createdAt;
    data[USER_LAST_UPDATED] = this.lastUpdated;
    data[USER_PUST_TOKEN] = this.pushToken;
    data[USER_ISlOGIN] = this.isLogin;
    data[USER_ACCOUNT_TYPE] = this.accountType;
    data[USER_ALLOW_SEARCH] = this.allowSearch;
    data[USER_LOCATION_LAT] = this.latitude;
    data[USER_LOCATION_LONG] = this.longitude;
    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      //idDB = json['UserModel']['idDB'],
      id: json[USER_ID],
      userName: json[USER_USERNAME],
      fullName: json[USER_FULLNAME],
      birthday: json[USER_BIRTHDAY],
      gender: json[USER_GENDER],
      email: json[USER_EMAIL],
      photoURL: json[USER_PHOTO_URL],
      cover: json[USER_COVER],
      statusAccount: json[USER_STATUS_ACCOUNT],
      phoneNumber: json[USER_PHONE],
      createdAt: json[USER_CREATED_AT],
      lastUpdated: json[USER_LAST_UPDATED]==null?'':json[USER_LAST_UPDATED],// todo check field exist
      pushToken: json[USER_PUST_TOKEN],
      isLogin: json[USER_ISlOGIN] as bool,
      accountType: json[USER_ACCOUNT_TYPE],
      allowSearch: json[USER_ALLOW_SEARCH] as bool,
      latitude: json[USER_LOCATION_LAT],
      longitude: json[USER_LOCATION_LONG]);

  factory UserModel.fromDocumentSnapshot (DocumentSnapshot doc) =>UserModel(
      id: doc[USER_ID],
      userName: doc[USER_USERNAME],
      fullName: doc[USER_FULLNAME],
      birthday: doc[USER_BIRTHDAY],
      gender: doc[USER_GENDER],
      email: doc[USER_EMAIL],
      photoURL: doc[USER_PHOTO_URL],
      cover: doc[USER_COVER],
      statusAccount: doc[USER_STATUS_ACCOUNT],
      phoneNumber: doc[USER_PHONE],
      createdAt: doc[USER_CREATED_AT],
      lastUpdated: doc.get(USER_LAST_UPDATED)==null?'':doc[USER_LAST_UPDATED],// todo hiện tại ko ko thể check null
      pushToken: doc[USER_PUST_TOKEN],
      isLogin: doc[USER_ISlOGIN] as bool,
      accountType: doc[USER_ACCOUNT_TYPE],
      allowSearch: doc[USER_ALLOW_SEARCH] as bool,
      latitude: doc[USER_LOCATION_LAT],
      longitude: doc[USER_LOCATION_LONG]
  );

  @override
  String toString() {
    return 'UserModel{idDB: $idDB, id: $id, userName: $userName, fullName: $fullName, birthday: $birthday, gender: $gender, email: $email, photoURL: $photoURL, cover: $cover, statusAccount: $statusAccount, phoneNumber: $phoneNumber, createdAt: $createdAt, lastUpdated: $lastUpdated, pushToken: $pushToken, isLogin: $isLogin, accountType: $accountType, allowSearch: $allowSearch, latitude: $latitude, longitude: $longitude}';
  }
}
