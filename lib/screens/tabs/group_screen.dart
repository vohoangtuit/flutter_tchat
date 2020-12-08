import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/widget/toolbar_main.dart';
class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> with WidgetsBindingObserver{//AutomaticKeepAliveClientMixin<GroupScreen>,
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Text('Group'),
          ),
        ],
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  //  print('group screen initState()');
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override//                     AppLifecycleState state
  void didChangeAppLifecycleState(AppLifecycleState state) {//didChangeAppLifecycleState
    state = state;
    print(state);
    print(":::::::");                                         //didChangeAppLifecycleState
    switch (state) {
      case AppLifecycleState.resumed:
        print('GroupScreen resumed()');

        break;
      case AppLifecycleState.inactive:
        print('GroupScreen inactive()');

        break;
      case AppLifecycleState.paused:
        print('GroupScreen paused()');

        break;
      case AppLifecycleState.detached:
        print('GroupScreen paused()');

        break;

    }
  }
}
