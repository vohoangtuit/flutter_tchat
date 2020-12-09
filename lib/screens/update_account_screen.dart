import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/widget/widget.dart';

import '../utils/const.dart';

class UpdateAccountScreen extends StatefulWidget {
  UserModel user;
  UpdateAccountScreen(this.user);
  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends BaseStatefulWidget<UpdateAccountScreen> {
  TextEditingController controllerFullName = TextEditingController();
  TextEditingController controllerAboutMe = TextEditingController();

  SharedPreferences prefs;

  String id = '';
  String fullName = '';
  String aboutMe = '';
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  int _stackIndex = 0;
  String _singleValue = "Male";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWithTitleCenter(context, 'Profile Information'),
        //  body: UpdateScreen(),
        body:userModel==null?Container(): Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  information(),
                  // Input
                  Column(
                    children: <Widget>[
                      // Username
                      Container(
                        child: Text(
                          'Nickname',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: primaryColor),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Sweetie',
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: greyColor),
                            ),
                            controller: controllerFullName,
                            onChanged: (value) {
                              fullName = value;
                            },
                            focusNode: focusNodeFullName,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),

                      // About me
                      Container(
                        child: Text(
                          'About me',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                        margin:
                            EdgeInsets.only(left: 10.0, top: 30.0, bottom: 5.0),
                      ),
                      Container(
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(primaryColor: primaryColor),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Fun, like travel and play PES...',
                              contentPadding: EdgeInsets.all(5.0),
                              hintStyle: TextStyle(color: greyColor),
                            ),
                            controller: controllerAboutMe,
                            onChanged: (value) {
                              aboutMe = value;
                            },
                            focusNode: focusNodeAboutMe,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),

                  // Button
                  Container(
                    child: FlatButton(
                      onPressed: handleUpdateData,
                      child: Text(
                        'UPDATE',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: primaryColor,
                      highlightColor: Color(0xff8d93a0),
                      splashColor: Colors.transparent,
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                    ),
                    margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                  ),
                ],
              ),
            //  padding: EdgeInsets.only(left: 15.0, right: 15.0),
            ),
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor)),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ));
  }

  Widget information() {
    return Container(
      color: Colors.grey[300],
      margin: EdgeInsets.only(left: 0.0, top: 10.0, right: 0.0, bottom: 10.0),
      child: Container(
        margin: EdgeInsets.only(left: 0.0, top: 0.5, right: 0.0, bottom: 0.5),
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Stack(
                children: <Widget>[
                  (avatarImageFile == null)
                      ? (widget.user.photoURL != ''
                      ? Material(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(
                                  themeColor),
                            ),
                            width: 70.0,
                            height: 70.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                      imageUrl: widget.user.photoURL,
                      width: 70.0,
                      height: 70.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  )
                      : Icon(
                    Icons.account_circle,
                    size: 70.0,
                    color: greyColor,
                  ))
                      : Material(
                    child: Image.file(
                      avatarImageFile,
                      width: 70.0,
                      height: 70.0,
                      fit: BoxFit.cover,
                    ),
                    borderRadius:
                    BorderRadius.all(Radius.circular(45.0)),
                    clipBehavior: Clip.hardEdge,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: primaryColor.withOpacity(0.5),
                    ),
                    onPressed: getImage,
                    padding: EdgeInsets.all(30.0),
                    splashColor: Colors.transparent,
                    highlightColor: greyColor,
                    iconSize: 30.0,
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                //  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: inputDecoratio('Full Name'),
                            controller: controllerFullName,
                            onChanged: (value) {
                              userModel.fullName = value;
                            },
                            focusNode: focusNodeFullName,
                          ),
                        ),
                        Container(
                            alignment: Alignment.centerRight,
                            child: Image.asset('images/icons/ic_pen_gray.png',width: 15,height: 15,)),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        RadioButton(
                          description: "Male",
                          value: "Male",
                          groupValue: _singleValue,
                          onChanged: (value) => setState(
                                () => _singleValue = value,
                          ),
                        ),
                        RadioButton(
                          description: "FeMale",
                          value: "FeMale",
                          groupValue: _singleValue,
                          onChanged: (value) => setState(
                                () => _singleValue = value,
                          ),
                          textPosition: RadioButtonTextPosition.left,
                        ),
                      ],
                    ),Divider(),
                    Row(
                      children: [
                      Expanded(child: Text(widget.user.birthday.isEmpty?'01/01/1970':widget.user.birthday)),
                      Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset('images/icons/ic_pen_gray.png',width: 15,height: 15,)),
                    ],),
                    Divider(),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    fullName = prefs.getString('nickname') ?? '';
    aboutMe = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';

    controllerFullName = TextEditingController(text: widget.user.fullName);
    controllerAboutMe = TextEditingController(text: aboutMe);

    // Force refresh input


  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    File image = File(pickedFile.path);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          FirebaseFirestore.instance.collection('users').doc(id).update({
            'nickname': fullName,
            'aboutMe': aboutMe,
            'photoUrl': photoUrl
          }).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeFullName.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection('users').doc(id).update({
      'nickname': fullName,
      'aboutMe': aboutMe,
      'photoUrl': photoUrl
    }).then((data) async {
      await prefs.setString('nickname', fullName);
      await prefs.setString('aboutMe', aboutMe);
      await prefs.setString('photoUrl', photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }
}
