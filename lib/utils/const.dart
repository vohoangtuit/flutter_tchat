import 'dart:ui';

final themeColor = Color(0xFF42A5F5);
final primaryColor = Color(0xff203152);
final whiteColor = Color(0xFFFFFFFF);
final greyColor = Color(0xffaeaeae);
final greyColor2 = Color(0xffE8E8E8);

final String SOCKET_URL ="http://192.168.29.111:5000";
//final String SOCKET_URL ="https://chatsocket2008.herokuapp.com";

// todo Socket IO
final String SOCKET_TYPING ='typing';
final String SOCKET_STOP_TYPING ='stop_typing';
final String SOCKET_QUERY_ID_CHAT ='idChat';
final String SOCKET_SENDER_CHAT_ID ='senderChatID';
final String SOCKET_RECEIVER_CHAT_ID ='receiverChatID';
final String SOCKET_GROUP_CHAT_ID ='groupChatId';
final String SOCKET_DISCONNECT ='disconnect';
final String SOCKET_USER_JOINED ='user_joined';
final String SOCKET_USER_LEFT ='user_left';

//---------todo Firebase------------
final String FIREBASE_ID ='id';
final String FIREBASE_USERS ='users';
final String FIREBASE_MESSAGES ='messages';
final String FIREBASE_GROUP ='groups';

class Const{

}
