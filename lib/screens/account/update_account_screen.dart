import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tchat_app/base/account_statefulwidget.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/firebase_services/upload.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/utils/utils.dart';
import 'package:tchat_app/widget/base_button.dart';
import 'package:tchat_app/widget/widget.dart';

import '../../utils/const.dart';

class UpdateAccountScreen extends StatefulWidget {
  UserModel user;
  UpdateAccountScreen(this.user);
  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState(user);
}

class _UpdateAccountScreenState extends AccountBaseState<UpdateAccountScreen> {
  final UserModel user;
  TextEditingController controllerFullName = TextEditingController();
  SharedPreferences prefs;


  bool isLoading = false;
  File avatarImageFile;

  DateTime selectedDate = DateTime.now();

  final FocusNode focusNodeFullName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();
  int _genderValue = 0;
  String birthday ='';
  String oldAvatar='';

  _UpdateAccountScreenState(this.user);
  //String timesnapBirthday='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
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
                            GestureDetector(
                              onTap: getImage,
                              child: Stack(
                                children: <Widget>[
                                  (avatarImageFile == null)
                                      ? (user.photoURL != ''
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
                                      imageUrl: user.photoURL,
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

    FirebaseUpload(uploadAvatarCover).uploadFileAvatar(user, avatarImageFile);
  }

  void handleUpdateData() {
    focusNodeFullName.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });

    FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(user.id).update({USER_FULLNAME:  user.fullName,USER_GENDER: user.gender,USER_BIRTHDAY:user.birthday, USER_PHOTO_URL: user.photoURL
    }).then((data) async {
      updateUserDatabase(user);
      ProviderController(context).setAccount(user);

      setState(() {
        isLoading = false;
        userModel =user;
        reloadUser =true;
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
        this.user.birthday =Utils().covertTimesnapToMilliseconds(selectedDate);
      });
  }

  @override
  void uploadAvatarCover(UserModel user, bool success) {
    print('uploadCallBack');
    setState(() {
      isLoading =false;
      if(success){
        ProviderController(context).setAccount(user);
        userModel =user;
        updateUserDatabase(user);
      }
    });
  }
}
