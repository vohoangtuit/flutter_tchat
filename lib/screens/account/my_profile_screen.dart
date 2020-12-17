import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/upload.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/account/update_account_screen.dart';
import 'package:tchat_app/screens/dialogs/dialog_controller.dart';
import 'package:tchat_app/utils/camera_library_open.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/sliver_appbar_delegate.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/widget/loading.dart';

import 'base_account_update.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends BaseAccountUpdate<MyProfileScreen> {
  ScrollController _scrollController;
  bool lastStatus = true;

  File avatarImageFile;
  File coverImageFile;

  @override
  Widget build(BuildContext context) {
    //userModel =ProviderController(context).getAccount();
    if (ProviderController(context).getUserUpdated()) {
      reload = getAccount(); // todo call back when user update info from other screen
    }
    if (userModel == null) {
      return Container();
    } else {
      return Scaffold(
        body: Stack(
          children: [
            DefaultTabController(
              length: 2,
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context_, bool innerBoxIsScrolled) {
                  context =context_;
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 225.0,
                      floating: true,
                      pinned: true,
                      primary: true,
                      snap: true,
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(
                        color: isShrink
                            ? Colors.black
                            : Colors.white, //change your color here
                      ),
                      actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.favorite,
                                color: isShrink ? Colors.black : Colors.white),
                            onPressed: () {
                              print('my favorite');
                            }),
                        IconButton(
                            icon: Icon(Icons.more_horiz,
                                color: isShrink ? Colors.black : Colors.white),
                            onPressed: () {
                              openScreen(UpdateAccountScreen(userModel));
                            })
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: EdgeInsets.only(
                            left: 50, top: 0.0, right: 0.0, bottom: 10.0),
                        title: Container(
                          // height: 225,
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                  width: 36.0,
                                  height: 36.0,
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage:  userModel.photoURL.isEmpty ? AssetImage(PATH_AVATAR_NOT_AVAILABLE):NetworkImage(userModel.photoURL),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                                onTap: () {
                                  DialogController(context).showDialogRequestUpdatePicture(dialog, PICTURE_TYPE_AVATAR, viewDialogPicture);
                                },
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                userModel.fullName,
                                textAlign: TextAlign.center,
                                style: isShrink
                                    ? mediumTextBlack()
                                    : mediumTextWhite(),
                              ),
                            ],
                          ),
                        ),
                        background: userModel.cover.isEmpty
                            ? InkWell(
                                child: Image.asset(
                                  PATH_COVER_NOT_AVAILABLE,
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  DialogController(context).showDialogRequestUpdatePicture(dialog, PICTURE_TYPE_COVER, viewDialogPicture);
                                },
                              )
                            : InkWell(
                                child:
                                //CachedNetworkImageProvider(userModel.cover),
                                Image.network(userModel.cover, fit: BoxFit.cover,),
                                onTap: () {
                                  DialogController(context).showDialogRequestUpdatePicture(dialog, PICTURE_TYPE_COVER, viewDialogPicture);
                                }),
                      ),
                    ),
                    SliverPersistentHeader(
                      // todo using to keep when scroll to top
                      delegate: SliverAppBarDelegate(
                        TabBar(
                          labelColor: Colors.black87,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.wysiwyg),
                                  SizedBox(width: 10,),
                                  Text("Logs"),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo),
                                  SizedBox(width: 10,),
                                  Text("Photos"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text(
                        'data',
                        style: normalTextRed(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            isLoading ? LoadingCircle() : Container(),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void initState() {

    //print('profile '+userModel.toString());
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }
  @override
  void updateProfile(UserModel user, bool success) {
    print('uploadCallBack');
    setState(() {
      isLoading = false;
      if (success) {
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
      });
      if(type ==PICTURE_TYPE_AVATAR){
        FirebaseUpload(updateProfile)
            .uploadFileAvatar(userModel, file);
      }else{
        FirebaseUpload(updateProfile)
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
      });
      if(type ==PICTURE_TYPE_AVATAR){
        FirebaseUpload(updateProfile).uploadFileAvatar(userModel, file);
      }else{
        FirebaseUpload(updateProfile).uploadFileCover(userModel, file);
      }
    }
  }

}
