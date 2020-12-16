import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/dialogs/dialog_controller.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/camera_library_open.dart';
import 'package:tchat_app/utils/const.dart';

abstract class BaseAccountUpdate <T extends StatefulWidget> extends AccountBaseState {
 // TODO: this class using for screen update account implement more function
  var reload;
  void callBackCamera(File file, type);
  void callBackLibrary(File file, type);

  void uploadAvatarCover(UserModel user,bool success);// todo create callback
//  void cameraToUpload(File file);// todo create callback

  void saveAccountToShared(UserModel user)async{// todo create callback
    await SharedPre.saveString(SharedPre.sharedPreUSer, jsonEncode(user));
    ProviderController(context).setUserUpdated(true);
    getAccount();
  }
  viewDialogPicture(int type, int choose) async{// todo type: 1 avatar,2 cover || choose : 1 take picture,2 library
    if(type==PICTURE_TYPE_AVATAR){
      if(choose ==CHOOSE_PICTURE_CAMERA){
        CameraLibraryOpening(callBackCamera).cameraOpen(type);
      }else if(choose ==CHOOSE_PICTURE_VIEW_PICTURE){
        await  Future.delayed(Duration.zero, () async {
          DialogController(context).ShowDialogViewSingleImage(dialog, userModel.photoURL);
        });
      }
      else{
        CameraLibraryOpening(callBackCamera).libraryOpen(type);
      }

    }else if(type==PICTURE_TYPE_COVER){
      if(choose ==CHOOSE_PICTURE_CAMERA){
        CameraLibraryOpening(callBackCamera).cameraOpen(type);
      }else if(choose ==CHOOSE_PICTURE_VIEW_PICTURE){
        Future.delayed(Duration.zero, () async {
          DialogController(context).ShowDialogViewSingleImage(dialog, userModel.cover);
        });
      }
      else{
        CameraLibraryOpening(callBackCamera).libraryOpen(type);
      }
    }
  }
}
