import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tchat_app/base/account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/upload.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/account/update_account_screen.dart';
import 'package:tchat_app/widget/sliver_appbar_delegate.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/widget/loading.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends AccountBaseState<MyProfileScreen> {
  ScrollController _scrollController;
  bool lastStatus = true;

  File avatarImageFile;
  File coverImageFile;
  var reload;

  @override
  Widget build(BuildContext context) {
    //userModel =ProviderController(context).getAccount();
    if (ProviderController(context).getUserUpdated()) {
      reload =
          getAccount(); // todo call back when user update info from other screen
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
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
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
                                  decoration: BoxDecoration(
                                    color: const Color(0xff7c94b6),
                                    image: DecorationImage(
                                      image: userModel.photoURL.isEmpty
                                          ? AssetImage(
                                              'images/img_not_available.jpeg')
                                          : NetworkImage(userModel.photoURL),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(36.0)),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  getImage(true);
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
                                  'images/cover.png',
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  getImage(false);
                                },
                              )
                            : InkWell(
                                child: Image.network(
                                  userModel.cover,
                                  fit: BoxFit.cover,
                                ),
                                onTap: () {
                                  getImage(false);
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

  uploadCallBack(UserModel user, bool success) {
    // todo handle upload from other class and callback
  }

  Future getImage(bool avatar) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    File image = File(pickedFile.path);

    if (image != null) {
      setState(() {
        if (avatar) {
          avatarImageFile = image;
        } else {
          coverImageFile = image;
        }
        isLoading = true;
      });
    }
    if (avatar) {
      FirebaseUpload(uploadAvatarCover)
          .uploadFileAvatar(userModel, avatarImageFile);
    } else {
      FirebaseUpload(uploadAvatarCover)
          .uploadFileCover(userModel, coverImageFile);
    }
  }

  @override
  void uploadAvatarCover(UserModel user, bool success) {
    print('uploadCallBack');
    setState(() {
      isLoading = false;
      if (success) {
        saveAccountToShared(user);
      }
    });
  }
}
