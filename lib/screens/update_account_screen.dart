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
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/utils/utils.dart';
import 'package:tchat_app/widget/base_button.dart';
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
  SharedPreferences prefs;

  String id = '';
  String fullName = '';
  String aboutMe = '';
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  DateTime selectedDate = DateTime.now();

  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  int _genderValue = 0;
  String birthday ='';
  //String timesnapBirthday='';
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
                  Container(
                      child: BaseButton(title: 'Update',onPressed: (){
                        handleUpdateData();
                      },),
                    margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                  ),
                ],
              ),
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
    return Column(
      children: [
        Divider(height: 1),
        Container(
        margin:EdgeInsets.only(top: 14),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Divider(height: 1),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Container(
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

                                Positioned.fill(
                                  left: 0.0,top: 0.0,right: 0.0,bottom: 0.0,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Material(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0),),
                                      clipBehavior: Clip.hardEdge,
                                      shadowColor: Colors.black,
                                      child: Container(
                                        color: Colors.white,
                                        height: 20,width: 20,
                                        child: Positioned.fill(
                                          child: Icon(Icons.camera_alt, color: primaryColor.withOpacity(0.5),size: 15,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 35,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: inputDecoratio('Full Name'),
                                            controller: controllerFullName,
                                            onChanged: (value) {
                                              widget.user.fullName = value;
                                            },
                                            focusNode: focusNodeFullName,
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        iconEditInfo(),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    height: 35,
                                    child: Row(
                                      children: [
                                        Radio(
                                          value: 1,
                                          groupValue: _genderValue,
                                          onChanged: _handleRadioValueChange,
                                        ),
                                        Text('Male'),
                                        Radio(
                                          value: 0,
                                          groupValue: _genderValue,
                                          onChanged: _handleRadioValueChange,
                                        ),
                                        Text('Female'),
                                      ],
                                    ),
                                  ),
                                  Divider(),
                                  Container(
                                    height: 35,
                                    child: GestureDetector(
                                      onTap: (){
                                        _selectDate(context);
                                      },
                                      child: Row(
                                        children: [
                                        Expanded(child: Text(birthday)),
                                          iconEditInfo(),
                                      ],),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 0.5,
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }
  void _handleRadioValueChange(int value) {
    setState(() {
      _genderValue = value;
      widget.user.gender =_genderValue;
      switch (_genderValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }
  void readLocal() async {
    if(widget.user.gender!=null){
      setState(() {
        _genderValue =widget.user.gender;
      });
    }else{
      setState(() {
         widget.user.gender=_genderValue;
      });
    }
    controllerFullName = TextEditingController(text: widget.user.fullName);
     if(widget.user.birthday!=null){
       
       setState(() {
         birthday =Utils().formatTimesnapToDate(int.parse(widget.user.birthday));
       });

     }else{
       setState(() {
         birthday ='1/1/1990';
       });
     }


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
          widget.user.photoURL = downloadUrl;
          FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(id).update({
            USER_FULLNAME: widget.user.fullName,
            USER_GENDER: widget.user.gender,
            USER_PHOTO_URL: widget.user.photoURL
          }).then((data) async {
            //await prefs.setString('photoUrl', photoUrl);
            ProviderController(context).setAccount(widget.user);
            updateUserDatabase(widget.user);
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

    FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(widget.user.id).update({USER_FULLNAME:  widget.user.fullName,USER_GENDER: widget.user.gender,USER_BIRTHDAY:widget.user.birthday, USER_PHOTO_URL: widget.user.photoURL
    }).then((data) async {
      updateUserDatabase(widget.user);
      ProviderController(context).setAccount(widget.user);

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
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2021),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        birthday =Utils().formatDate_dd_mm_yyy(selectedDate);
        widget.user.birthday =Utils().covertTimesnapToMilliseconds(selectedDate);
      });
  }
}
