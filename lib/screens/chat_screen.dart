import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/models/message._model.dart';
import 'package:tchat_app/screens/video_call.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/full_photo.dart';
import 'package:tchat_app/widget/loading.dart';
import 'package:tchat_app/widget/text_style.dart';

import 'items/ItemChatMessage.dart';

class ChatScreen extends StatefulWidget {
   String toId;
   String photoUrl;
   String fullName;
  ChatScreen(this.toId, this.photoUrl, this.fullName);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseStatefulState<ChatScreen> {
  ClientRole role = ClientRole.Broadcaster;
  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  SocketIO socketIO;
  bool typing =false;

  String groupChatId="";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.fullName,style: mediumTextWhite(),),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              //authMethods.signOut();
              // SharedPre.clearData();
              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              //child: IconButton( icon: new Image.asset('images/icons/camera_white.png',width: 28,height: 28,),
              // onPressed: () => callVideo()),
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0,top: 2.0,right: 0.0,bottom: 0.0),
                child: Row(
                  children: [
                    IconButton(icon: new Image.asset('images/icons/phone_white.png',width: 28,height: 22,),onPressed: ()=> audioVideo()),
                    IconButton(icon: new Image.asset('images/icons/camera_white.png',width: 28,height: 28,),onPressed: ()=> callVideo()),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),
                  // Sticker
                  (isShowSticker ? buildSticker() : Container()),
                  buildTyping(),

                  // Input content
                  buildInput(),
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
          onWillPop: onBackPress,
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    initData();
  }
  callVideo() async{
    print('call video');
    await _handleCameraAndMic();
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>VideoCall(role: role,)));

  }

  audioVideo(){
    print('audio call');

  }
  Future<void> _handleCameraAndMic() async {
    print("permission");
    await PermissionHandler().requestPermissions(
      [PermissionGroup.camera, PermissionGroup.microphone],
    );
  }
  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  initData() async{
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    groupChatId = idMe+'-'+widget.toId;

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';

    print("photoUrl ${widget.photoUrl}");
    //initSocket();

    textEditingController.addListener(() {
      if(textEditingController.text.isNotEmpty){
        if(typing)
          return;
        typing =true;
        //socketIO.sendMessage(Const().SOCKET_TYPING, json.encode({Const().SOCKET_GROUP_CHAT_ID: groupChatId,Const().SOCKET_SENDER_CHAT_ID: id}));
      }else{
        if(!typing)
          return;
        typing =false;
       // socketIO.sendMessage(Const().SOCKET_STOP_TYPING, json.encode({Const().SOCKET_GROUP_CHAT_ID: groupChatId,Const().SOCKET_SENDER_CHAT_ID: id}));
      }
    });
  }
  @override
  void dispose(){
    super.dispose();
    socketIO.sendMessage(// todo send message to server socket
      'unsubscribe',
      json.encode({
        'groupChatId': groupChatId, // todo re update
      }),
    );
    socketIO.disconnect();

    textEditingController.dispose();
  }
  initSocket()async{
    await SharedPre.getStringKey(SharedPre.sharedPreFullName).then((value) => {
      widget.fullName =value
    });

    //socketIO = SocketIOManager().createSocketIO(Const().SocketChat, "/");
    socketIO = SocketIOManager().createSocketIO(SOCKET_URL, "/",
        query: 'idChat=''',socketStatusCallback: _socketStatus);

    socketIO.init();
    socketIO.sendMessage(// todo send message to server socket
      'subscribe',
      json.encode({
        'groupChatId': groupChatId,
      }),
    );

    // todo: listener events from server socket
    socketIO.subscribe(SOCKET_TYPING, userTyping);
    socketIO.subscribe(SOCKET_STOP_TYPING, stopTyping);

    socketIO.subscribe(SOCKET_USER_JOINED, userJoined);
    socketIO.subscribe(SOCKET_USER_LEFT, userLeft);

    //     //Connect to the socket
    socketIO.connect();

  }
  _socketStatus(dynamic data) {
    print("Socket status: " + data);
  }
  void userTyping(dynamic data){
    print(data);
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    print("typing -------------------- $map");
    setState(() {
      typing=true;
    });
  }
  void stopTyping(dynamic data){
    print(data);
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    print("stopTyping -------------------- $map");
    setState(() {
      typing=false;
    });
  }
  void userJoined(dynamic data){
    print(data);
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    print("userJoined -------------------- $map");
  }
  void userLeft(dynamic data){
    print(data);
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    print("userLeft -------------------- $map");
  }
  void receiveMessage(dynamic data){
    print("receiveMessage "+data);
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    print("receive_message -------------------- $map");
    setState(() {
      typing=false;
    });

  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }
  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
       Message messages =Message(idFrom:idMe, idTo:widget.toId, timestamp:DateTime.now().millisecondsSinceEpoch.toString(), content:content, type:type, status:0);
       var from =fireBaseStore.collection(FIREBASE_MESSAGES).doc(idMe).collection(widget.toId).doc();// end doc can use timestamp
       var to =fireBaseStore.collection(FIREBASE_MESSAGES).doc(widget.toId).collection(idMe).doc();// end doc can use timestamp
       WriteBatch writeBatch =fireBaseStore.batch();
       writeBatch.set(from, messages.toJson());
       writeBatch.set(to, messages.toJson());
    writeBatch.commit().then((value) => ()=>{
      print('Create message ')

    }).catchError((onError){
      print(('create message error $onError'));
    });


      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }



  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi1', 2),
                child: Image.asset(
                  'images/mimi1.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi2', 2),
                child: Image.asset(
                  'images/mimi2.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi3', 2),
                child: Image.asset(
                  'images/mimi3.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi4', 2),
                child: Image.asset(
                  'images/mimi4.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi5', 2),
                child: Image.asset(
                  'images/mimi5.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi6', 2),
                child: Image.asset(
                  'images/mimi6.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () => onSendMessage('mimi7', 2),
                child: Image.asset(
                  'images/mimi7.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi8', 2),
                child: Image.asset(
                  'images/mimi8.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              ),
              FlatButton(
                onPressed: () => onSendMessage('mimi9', 2),
                child: Image.asset(
                  'images/mimi9.gif',
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(

                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    print("id: $idMe - toId: ${widget.toId}");
    return Flexible(
      child: idMe == ''
          ? Center(
              child: CircularProgressIndicator(
                  //valueColor: AlwaysStoppedAnimation<Color>(themeColor)
              ))

          : StreamBuilder(
              stream: fireBaseStore
                  .collection(FIREBASE_MESSAGES)
                  .doc(idMe)
                  .collection(widget.toId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print("cannot get data");
                  return Center(
                      child: CircularProgressIndicator(
                        //  valueColor: AlwaysStoppedAnimation<Color>(themeColor)
                      )
                  );
                } else {
                  listMessage.addAll(snapshot.data.documents);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                    ItemChatMessage(context,idMe,index,snapshot.data.documents[index],listMessage,widget.photoUrl),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }
  Widget buildTyping(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
              typing?'Typing...':'',style: TextStyle(color: Colors.lightBlue,fontSize: 11),
          ),
        ),
      ],
    );
  }

}