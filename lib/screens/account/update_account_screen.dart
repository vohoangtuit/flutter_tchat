import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tchat_app/controller/providers/providers.dart';

import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/firebase_services/upload.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/account/base_account_update.dart';
import 'package:tchat_app/screens/dialogs/dialog_controller.dart';

import 'package:tchat_app/utils/utils.dart';
import 'package:tchat_app/widget/base_button.dart';
import 'package:tchat_app/widget/widget.dart';
import 'package:tchat_app/widget/loading.dart';

import '../../utils/const.dart';

class UpdateAccountScreen extends StatefulWidget {
  UserModel user;
  UpdateAccountScreen(this.user);
  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState(user);
}

class _UpdateAccountScreenState extends BaseAccountUpdate<UpdateAccountScreen> {
  final UserModel user;
  TextEditingController controllerFullName = TextEditingController();
  SharedPreferences prefs;

  File avatarImageFile;

  DateTime selectedDate = DateTime.now();

  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  int _genderValue = 0;
  String birthday ='';
  String oldAvatar='';
  _UpdateAccountScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    if (ProviderController(context).getUserUpdated()) {
      reload = getAccount(); // todo call back when user update info from other screen
    }
    return userModel==null?Container():Scaffold(
        appBar: appBarWithTitleCenter(context, 'Profile Information'),
        //  body: UpdateScreen(),
        body: Stack(
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
            isLoading
                ? LoadingCircle()
                : Container(),
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
                            InkWell(
                              onTap: (){
                                DialogController(context).showDialogRequestUpdatePicture(dialog, PICTURE_TYPE_AVATAR, viewDialogPicture);
                              },
                              child: Stack(
                                children: <Widget>[
                                  (avatarImageFile == null) ? (user.photoURL != '' ? Material(
                                    child: cachedImage(user.photoURL,70.0,70.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(45.0)),
                                    clipBehavior: Clip.hardEdge,
                                  ) : iconNoImage(70.0)) : loadFileMaterial(avatarImageFile,70.0,70.0),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    width: 70,
                                    height: 70,
                                    child: Material(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0),),
                                      clipBehavior: Clip.hardEdge,
                                      shadowColor: Colors.black,
                                        child: Container(
                                          color: Colors.white,
                                          height: 20,width: 20,
                                          child: Icon(Icons.camera_alt, color: primaryColor.withOpacity(0.5),size: 15,),
                                        ),
                                      ),
                                    ),

                                ],
                              ),
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
                                              user.fullName = value;
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
     user.gender =_genderValue;
      switch (_genderValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }
  void readLocal() async {
    if(user.gender!=null){
      setState(() {
        _genderValue =user.gender;
      });
    }else{
      setState(() {
         user.gender=_genderValue;
      });
    }
    controllerFullName = TextEditingController(text: user.fullName);
     if(user.birthday.isNotEmpty){
       
       setState(() {
         birthday =Utils().formatTimesnapToDate(int.parse(user.birthday));
       });

     }else{
       setState(() {
         birthday ='1/1/1990';
       });
     }


  }

  void handleUpdateData() {
    focusNodeFullName.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(user.id).update({USER_FULLNAME:  user.fullName,USER_GENDER: user.gender,USER_BIRTHDAY:user.birthday, USER_PHOTO_URL: user.photoURL
    }).then((data) async {
     // updateUserDatabase(user);
      setState(() {
        isLoading = false;
      });
      saveAccountToShared(user);
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
        this.user.birthday =Utils().covertTimesnapToMilliseconds(selectedDate);
      });
  }

  @override
  void uploadAvatarCover(UserModel user, bool success) {
    print('uploadCallBack');
    setState(() {
      isLoading =false;
      if(success){
        saveAccountToShared(user);
      }
    });
  }

  @override
  void callBackCamera(File file, type) {
    setState(() {
      isLoading =false;
    });
    if(file!=null){
      setState(() {
        isLoading =true;
        avatarImageFile =file;
      });
      if(type ==PICTURE_TYPE_AVATAR){
        FirebaseUpload(uploadAvatarCover)
            .uploadFileAvatar(userModel, file);
      }else{
        FirebaseUpload(uploadAvatarCover)
            .uploadFileCover(userModel, file);
      }
    }
  }

  @override
  void callBackLibrary(File file, type) {
    setState(() {
      isLoading =false;
    });
    if(file!=null){
      setState(() {
        isLoading =true;
        avatarImageFile =file;
      });
      if(type ==PICTURE_TYPE_AVATAR){
        FirebaseUpload(uploadAvatarCover).uploadFileAvatar(userModel, file);
      }else{
        FirebaseUpload(uploadAvatarCover).uploadFileCover(userModel, file);
      }
    }
  }
}
