import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/screens/update_account_screen.dart';
import 'package:tchat_app/widget/button.dart';
import 'package:tchat_app/widget/text_style.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends BaseStatefulState<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: true,
              pinned: true,

              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
                title: Text(
                  userModel.fullName,
                  style: mediumTextWhite(),
                ),
                titlePadding: EdgeInsets.only(left: 53.0,bottom: 18),
                background: userModel.cover.isEmpty?Image.asset(
                  'images/cover.png',
                  fit: BoxFit.cover,
                ):Image.network(
                  userModel.cover,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ];
        },
      body: Column(
        children: [
          Text('data'),
        ],
      ),
    );
  }
}
