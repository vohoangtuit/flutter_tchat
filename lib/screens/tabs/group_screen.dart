import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
class GroupScreen extends StatefulWidget {
  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends BaseStatefulState<GroupScreen> with AutomaticKeepAliveClientMixin<GroupScreen>{//
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  @override
  void initState() {
    super.initState();
  //  print('group screen initState()');
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void onDetached() {
    print('Group screen onDetached()');
  }

  @override
  void onInactive() {
    print('Group screen onInactive()');
  }

  @override
  void onPaused() {
    print('Group screen onPaused()');
  }

  @override
  void onResumed() {
    print('Group screen onResumed()');
  }
}
