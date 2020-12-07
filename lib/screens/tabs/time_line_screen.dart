import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/widget/view_header_main_screen.dart';
class TimeLineScreen extends StatefulWidget {
  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends BaseStatefulState<TimeLineScreen> with AutomaticKeepAliveClientMixin<TimeLineScreen>{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          headerMessage(),
          Expanded(
            child: Text('TimeLines'),
          ),
        ],
      ),
    );
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


}
