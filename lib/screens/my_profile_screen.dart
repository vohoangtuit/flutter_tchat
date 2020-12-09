import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/screens/update_account_screen.dart';
import 'package:tchat_app/widget/button.dart';
import 'package:tchat_app/widget/sliver_appbar_delegate.dart';
import 'package:tchat_app/widget/text_style.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends BaseStatefulWidget<MyProfileScreen> {
  ScrollController _scrollController;
  bool lastStatus = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                  titlePadding: EdgeInsets.only(left: 50,top: 0.0,right: 0.0,bottom: 10.0),
                  title: Container(
                   // height: 225,
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 36.0,
                          height: 36.0,
                          decoration: BoxDecoration(
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                              image: userModel.photoURL.isEmpty
                                  ? AssetImage('img_not_available.jpeg')
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
                        SizedBox(width: 10,),
                        Text(userModel.fullName, textAlign: TextAlign.center,style:isShrink? mediumTextBlack():mediumTextWhite(),),
                      ],
                    ),
                  ),
                  background: userModel.cover.isEmpty
                      ? Image.asset(
                          'images/cover.png',
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          userModel.cover,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SliverPersistentHeader(// todo using to keep when scroll to top
                delegate: SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.info), text: "Tab 1"),
                      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
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
    );
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
    return _scrollController.hasClients && _scrollController.offset > (200 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }
}

