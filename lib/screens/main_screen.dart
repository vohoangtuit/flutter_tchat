import 'package:flutter/material.dart';
import 'package:tchat_app/screens/tabs/group_screen.dart';
import 'package:tchat_app/screens/tabs/message_screen.dart';
import 'package:tchat_app/screens/tabs/more_screen.dart';
import 'package:tchat_app/screens/tabs/time_line_screen.dart';
import 'package:tchat_app/widget/text_style.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{
  TabController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TChat Application'),
        centerTitle: false,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),// todo: disable swip
        children: <Widget>[MessageScreen(), GroupScreen(), TimeLineScreen(), MoreScreen()],
        // set the controller
        controller: controller,
      ),
      bottomNavigationBar: Material(
        // set the color of the bottom navigation bar
        color: Colors.white,
        // set the tab bar as the child of bottom navigation bar
        child: TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(color:Colors.blue,fontSize: 11.0),//,fontFamily: 'Family Name'
          unselectedLabelStyle: TextStyle(color:Colors.grey,fontSize:11.0),//,fontFamily: 'Family Name'
          tabs:listTab(),
          controller: controller,
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    // Dispose of the Tab Controller
    controller.dispose();
    super.dispose();
  }
  void _handleTabSelection() {
    setState(() {
    });
  }
  List<Tab> listTab(){
    return <Tab>[
      // todo: custom view tabs
      Tab(child: Column(children: [
        SizedBox(height: 3,),
        Icon(Icons.message, color: controller.index == 0 ? Colors.blue : Colors.grey),
        Text("Message"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 3,),
        Icon(Icons.group, color: controller.index == 1 ? Colors.blue : Colors.grey),
        Text("Group"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 3,),
        Icon(Icons.timelapse_outlined, color: controller.index == 2 ? Colors.blue : Colors.grey),
        Text("TimeLine"),
      ],)),
      Tab(child: Column(children: [
        SizedBox(height: 3,),
        Icon(Icons.category, color: controller.index == 3 ? Colors.blue : Colors.grey),
        Text("More"),
      ],)),
    ];
  }
}
