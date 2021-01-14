
final String USER_ONLINE_UID ='uid';
final String USER_ONLINE_NAME ='name';
final String USER_LAST_ACCESS ='last_access';
final String USER_IS_ONLINE ='is_online';
class UserOnLineModel{
  String uid;
  String name;
  String lastAccess;
  bool isOnline;
  UserOnLineModel({this.uid,this.name,this.lastAccess,this.isOnline});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[USER_ONLINE_UID] = this.uid;
    data[USER_ONLINE_NAME] = this.name;
    data[USER_LAST_ACCESS] = this.lastAccess;
    data[USER_IS_ONLINE] = this.isOnline;
    return data;
  }
  factory UserOnLineModel.fromJson(Map<String, dynamic> json)=>UserOnLineModel(
      uid: json[USER_ONLINE_UID],
      name: json[USER_ONLINE_NAME],
      lastAccess: json[USER_LAST_ACCESS],
      isOnline: json[USER_IS_ONLINE]
  );

  @override
  String toString() {
    return 'UserOnLineModel{uid: $uid, name: $name, lastAccess: $lastAccess, isOnline: $isOnline}';
  }
}