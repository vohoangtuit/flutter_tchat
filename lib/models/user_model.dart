
//---------todo UserModel------------
import 'package:floor/floor.dart';
final String USER_MODEL ='UserModel';
final String USER_ID ='id';
final String USER_USERNAME ='userName';
final String USER_FULLNAME ='fullName';
final String USER_EMAIL ='email';
final String USER_PHOTO_URL ='photoURL';
final String USER_PHONE ='phoneNumber';
final String USER_BIRTHDAY ='birthday';
final String USER_CREATED_AT ='createdAt';
final String USER_STATUS_ACCOUNT ='statusAccount';
final String USER_PUST_TOKEN ='pushToken';
final String USER_ISlOGIN ='isLogin';

@entity
class UserModel {
  @PrimaryKey(autoGenerate: true)
  int idDB;
  String id='';
  String userName='';
  String fullName='';
  String birthday='';
  String email='';
  String photoURL='';
  int statusAccount=0;
  String phoneNumber='';
  String createdAt='';
  String pushToken='';
  bool isLogin;

  UserModel({this.idDB,this.id, this.userName,this.fullName, this.birthday, this.email, this.photoURL, this.statusAccount,this.phoneNumber, this.createdAt,this.pushToken,this.isLogin}) {
    // this.idDB = idDB;
    // this.id = id;
    // this.userName = userName;
    // this.fullName = fullName;
    // this.birthday = birthday;
    // this.email = email;
    // this.photoURL = photoURL;
    // this.statusAccount = statusAccount;
    // this.phoneNumber = phoneNumber;
    // this.createdAt = createdAt;
    // this.isLogin = isLogin;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[USER_ID] = this.id;
    data[USER_USERNAME] = this.userName;
    data[USER_FULLNAME] = this.fullName;
    data[USER_BIRTHDAY] = this.birthday;
    data[USER_EMAIL] = this.email;
    data[USER_PHOTO_URL] = this.photoURL;
    data[USER_STATUS_ACCOUNT] = this.statusAccount;
    data[USER_PHONE] = this.phoneNumber;
    data[USER_CREATED_AT] = this.createdAt;
    data[USER_PUST_TOKEN] = this.pushToken;
    data[USER_ISlOGIN] = this.isLogin;
    return data;
  }

  @override
  String toString() {
    return 'UserModel{idDB: $idDB, id: $id, userName: $userName, fullName: $fullName, birthday: $birthday, email: $email, photoURL: $photoURL, statusAccount: $statusAccount, phoneNumber: $phoneNumber, createdAt: $createdAt, pushToken: $pushToken, isLogin: $isLogin}';
  }
//migrations

}
