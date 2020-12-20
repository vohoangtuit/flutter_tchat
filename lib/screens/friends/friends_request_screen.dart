import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/screens/tabs/request/my_request_screen.dart';
import 'package:tchat_app/screens/tabs/request/user_request_screen.dart';
import 'package:tchat_app/widget/basewidget.dart';

class FriendsRequestScreen extends StatefulWidget {
  @override
  _FriendsRequestScreenState createState() => _FriendsRequestScreenState();
}

class _FriendsRequestScreenState extends AccountBaseState<FriendsRequestScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithTitle(context, 'Friend Requests'),
      body: Column(
        children: [
          initTabBar(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget initTabBar() {
    return Expanded(
      child: Column(
        children: [
          Container(
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.black,
              indicatorWeight: 1,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey[600],
              tabs: listTab(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[MyRequestScreen(), UserRequestScreen()],
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
            Text("My Request"),
          ],
        ),
      ),
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("User Request"),
          ],
        ),
      ),
    ];
  }
}
