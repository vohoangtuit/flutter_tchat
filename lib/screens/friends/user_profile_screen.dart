import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/chat_screen.dart';
import 'package:tchat_app/screens/dialogs/dialog_controller.dart';
import 'package:tchat_app/screens/tabs/profile/profile_photos.dart';
import 'package:tchat_app/screens/tabs/profile/profile_timeline.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/button/custom_button_with_title.dart';
import 'package:tchat_app/widget/loading.dart';
import 'package:tchat_app/widget/sliver_appbar_delegate.dart';
import 'package:tchat_app/widget/text_style.dart';

class UserProfileScreen extends StatefulWidget {
  UserModel myProfile;
  UserModel user;

  UserProfileScreen({this.myProfile, this.user});

  @override
  _UserProfileScreenState createState() =>
      _UserProfileScreenState(myProfile, user);
}

class _UserProfileScreenState extends AccountBaseState<UserProfileScreen> {
  UserModel myProfile;
  UserModel user;
  TabController _tabController;

  _UserProfileScreenState(this.myProfile, this.user);

  ScrollController _scrollController;
  bool lastStatus = true;

  // bool isFriend = false;
  int statusRequest = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DefaultTabController(
            length: 2,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context_, bool innerBoxIsScrolled) {
                context = context_;
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
                            print('more');
                            //   openScreen(UpdateAccountScreen(userModel));
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
                                  backgroundImage: user.photoURL.isEmpty
                                      ? AssetImage(PATH_AVATAR_NOT_AVAILABLE)
                                      : NetworkImage(user.photoURL),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              onTap: () {
                                DialogController(context)
                                    .ShowDialogViewSingleImage(
                                        dialog, user.photoURL);
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              user.fullName,
                              textAlign: TextAlign.center,
                              style: isShrink
                                  ? textBlackMedium()
                                  : textWhiteMedium(),
                            ),
                          ],
                        ),
                      ),
                      background: user.cover.isEmpty
                          ? InkWell(
                              child: Image.asset(
                                PATH_COVER_NOT_AVAILABLE,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                //DialogController(context).ShowDialogViewSingleImage(dialog, userModel.cover);
                              },
                            )
                          : InkWell(
                              child:
                                  //CachedNetworkImageProvider(userModel.cover),
                                  Image.network(
                                user.cover,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                DialogController(context)
                                    .ShowDialogViewSingleImage(
                                        dialog, user.cover);
                              }),
                    ),
                  ),
                  // SliverPersistentHeader(
                  //   // todo using to keep when scroll to top
                  //   delegate: SliverAppBarDelegate(
                  //     TabBar(
                  //       labelColor: Colors.black87,
                  //       unselectedLabelColor: Colors.grey,
                  //       indicatorSize: TabBarIndicatorSize.tab,
                  //       tabs: [
                  //         Tab(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(Icons.wysiwyg),
                  //               SizedBox(width: 10,),
                  //               Text("Logs"),
                  //             ],
                  //           ),
                  //         ),
                  //         Tab(
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(Icons.photo),
                  //               SizedBox(width: 10,),
                  //               Text("Photos"),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   pinned: true,
                  //  // children: <Widget>[ProfileTimeLine(), ProfilePhotos()],
                  // ),
                ];
              },
              body: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        //isFriend ? Container() : viewAddFriend(),
                        statusRequest == FRIEND_NOT_REQUEST
                            ? viewAddFriend()
                            : statusRequest == FRIEND_SEND_REQUEST
                                ? viewAddFriend()
                                : statusRequest == FRIEND_WAITING_CONFIRM
                                    ? viewAcceptFriend()
                                    : Container(),
                        statusRequest == FRIEND_SUCEESS
                            ? viewTabBarActivity()
                            : Container(),
                      ],
                    ),
                    statusRequest == FRIEND_WAITING_CONFIRM
                        ? viewButtonChat()
                        : statusRequest == FRIEND_SUCEESS
                            ? viewButtonChat()
                            : Container(),
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
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    // _tabController = new TabController(length: 2, vsync: this);
    checkIsFriend();
  }

  Widget viewAddFriend() {
    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding:
            const EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 10),
        child: Column(
          children: [
            Text(
              'Make friend with ${user.fullName} and have cool and unforgettable conversations together!',
              style: textBlackMedium(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButtonWithTitle(
                  title: 'MESSAGE',
                  colorButton: Colors.blue[100],
                  colorText: Colors.blue,
                  sizeText: 13.0,
                  onPressed: () {
                    openScreen(ChatScreen(user));
                  },
                ),
                CustomButtonWithTitle(
                  title: statusRequest == FRIEND_NOT_REQUEST
                      ? 'ADD FRIEND'
                      : 'UNDO REQUEST',
                  colorButton: statusRequest == FRIEND_NOT_REQUEST
                      ? Colors.blue
                      : Colors.blue[50],
                  colorText: statusRequest == FRIEND_NOT_REQUEST
                      ? Colors.white
                      : Colors.black45,
                  sizeText: 13.0,
                  onPressed: () {
                    if (statusRequest == FRIEND_NOT_REQUEST) {
                      requestAddFriend();
                    } else if (statusRequest == FRIEND_SEND_REQUEST) {
                      undoRequest();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget viewAcceptFriend() {
    return Container(
      color: Colors.grey[50],
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 20, right: 30, bottom: 10),
        child: Column(
          children: [
            Text(
              'Wants to be friends',
              style: textBlackMedium(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomButtonWithTitle(
                  title: 'DECLINE',
                  colorButton: Colors.blue[100],
                  colorText: Colors.black,
                  sizeText: 13.0,
                  onPressed: () {
                    // declineFriend();
                    undoRequest();
                  },
                ),
                CustomButtonWithTitle(
                  title: 'ACCEPT',
                  colorButton: Colors.blue,
                  colorText: Colors.white,
                  sizeText: 13.0,
                  onPressed: () {
                    acceptFriend();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget viewButtonChat() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 10),
        child: ButtonTheme(
          child: RaisedButton(
            onPressed: () {
              openScreen(ChatScreen(user));
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: Container(
              width: 60,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 20,
                  ),
                  //  SizedBox(width: 8.0,),
                  Text(
                    'Chat',
                    style: textBlackNormal(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget viewTabBarActivity() {
    return Expanded(
      child: Column(
        children: [
          Container(
            child: TabBar(
              indicatorColor: Colors.blueGrey,
              indicatorWeight: 1,
              //indicatorSize: TabBarIndicatorSize.label,
           //   isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[350],
              tabs: listTab(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[ProfileTimeLine(), ProfilePhotos()],
            ),
          )
        ],
      ),
    );
  }

  List<Tab> listTab() {
    return <Tab>[
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wysiwyg),
            SizedBox(
              width: 8.0,
            ),
            Text("Logs"),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo),
            SizedBox(
              width: 8.0,
            ),
            Text("Photos"),
          ],
        ),
      ),
    ];
  }

  checkIsFriend() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot variable =
        await firebaseDataService.checkUserIsFriend(myProfile.id, user.id);
    // if(variable!=null){
    //   print('variable. '+variable.toString());
    //   setState(() {
    //     isLoading = false;
    //   });
    // }else{
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
    if (variable != null) {
      if (variable.data() != null) {
        print('variable ' + variable.data()['statusRequest'].toString());
        setState(() {
          statusRequest = variable.data()[FRIEND_STATUS_REQUEST];
          isLoading = false;
        });
      } else {
        setState(() {
          statusRequest = FRIEND_NOT_REQUEST;
          isLoading = false;
        });
        print('222222');
      }
    } else {
      setState(() {
        isLoading = false;
        statusRequest = FRIEND_NOT_REQUEST;
      });
      print('3333');
    }
  }

  requestAddFriend() async {
    // https://stackoverflow.com/questions/46618601/how-to-create-update-multiple-documents-at-once-in-firestore?noredirect=1&lq=1
    setState(() {
      isLoading = true;
    });
    FriendModel meRequest = FriendModel(
        id: user.id,
        fullName: user.fullName,
        photoURL: user.photoURL,
        statusRequest: FRIEND_SEND_REQUEST);
    FriendModel receiveRequest = FriendModel(
        id: myProfile.id,
        fullName: myProfile.fullName,
        photoURL: myProfile.photoURL,
        statusRequest: FRIEND_WAITING_CONFIRM);

    WriteBatch writeBatch = fireBaseStore.batch();
    DocumentReference from = fireBaseStore.collection(FIREBASE_FRIENDS).doc(myProfile.id).collection(myProfile.id).doc(user.id); // todo: lấy user id làm id trên firebase
   //DocumentReference from = fireBaseStore.collection(FIREBASE_FRIENDS).doc(myProfile.id).collection(user.id).doc(user.id); // todo: lấy user id làm id trên firebase
    //DocumentReference from = fireBaseStore.collection(FIREBASE_FRIENDS).doc(myProfile.id).collection(user.id).doc();todo id tự generate on firebase
    DocumentReference to = fireBaseStore.collection(FIREBASE_FRIENDS).doc(user.id).collection(user.id).doc(myProfile.id); // todo: lấy user id làm id trên firebase
   // DocumentReference to = fireBaseStore.collection(FIREBASE_FRIENDS).doc(user.id).collection(myProfile.id).doc(myProfile.id); // todo: lấy user id làm id trên firebase
    // DocumentReference to = fireBaseStore.collection(FIREBASE_FRIENDS).doc(user.id).collection(myProfile.id); todo id tự generate on firebase
    writeBatch.set(from, meRequest.toJson());
    writeBatch.set(to, receiveRequest.toJson());
    writeBatch.commit().then((value) {
      print('send request');
      setState(() {
        statusRequest = FRIEND_SEND_REQUEST;
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  undoRequest() async {
    print('undoRequest()');

    WriteBatch writeBatch = fireBaseStore.batch();
    DocumentReference from = fireBaseStore
        .collection(FIREBASE_FRIENDS)
        .doc(myProfile.id)
        .collection(user.id)
        .doc(user.id);
    DocumentReference to = fireBaseStore
        .collection(FIREBASE_FRIENDS)
        .doc(user.id)
        .collection(myProfile.id)
        .doc(myProfile.id);
    writeBatch.delete(from);
    writeBatch.delete(to);
    writeBatch.commit().then((value) {
      print('deleted request');
      setState(() {
        statusRequest = FRIEND_NOT_REQUEST;
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  acceptFriend() {
    // https://stackoverflow.com/questions/46618601/how-to-create-update-multiple-documents-at-once-in-firestore?noredirect=1&lq=1
    setState(() {
      isLoading = true;
    });
    WriteBatch writeBatch = fireBaseStore.batch();
    DocumentReference from = fireBaseStore
        .collection(FIREBASE_FRIENDS)
        .doc(myProfile.id)
        .collection(myProfile.id)
        .doc(user.id);
    DocumentReference to = fireBaseStore
        .collection(FIREBASE_FRIENDS)
        .doc(user.id)
        .collection(user.id)
        .doc(myProfile.id);
    writeBatch.update(from, {FRIEND_STATUS_REQUEST: FRIEND_SUCEESS});
    writeBatch.update(to, {FRIEND_STATUS_REQUEST: FRIEND_SUCEESS});

    writeBatch.commit().then((value) {
      setState(() {
        statusRequest = FRIEND_SUCEESS;
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }

  declineFriend() {}
}
