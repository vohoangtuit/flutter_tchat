import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends BaseStatefulState<TimeLineScreen> with AutomaticKeepAliveClientMixin<TimeLineScreen>{
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
@override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
  }


}
