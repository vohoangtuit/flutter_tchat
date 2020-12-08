
import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';

import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/screens/items/item_last_message.dart';
import 'package:tchat_app/widget/toolbar_main.dart';


class LastMessageScreen extends StatefulWidget  {
  @override
  _LastMessageScreenState createState() => _LastMessageScreenState();
}
class _LastMessageScreenState extends BaseStatefulState<LastMessageScreen> with AutomaticKeepAliveClientMixin<LastMessageScreen>  {
  //
  @override
//  TODO: implement wantKeepAlive
 bool get wantKeepAlive => true;
  List<LastMessageModel> listMessage = List();
  bool reloadMessage =false;
  bool loaded=false;
  var getInitData ;
  @override
  Widget build(BuildContext context) {
   //  print('LastMessageScreen BuildContext');
     //print('reloadMessage ${ProviderController(context).getReloadLastMessage()}');
     if(userModel!=null){
       this.getInitData =initData();
     }
    return Container(
      child: Column(
        children: [
          //headerMessage(),
          Expanded(
            child: listView(),
          ),
        ],
      ),

    );
  }

  @override
  void initState() {
    super.initState();
    if(userModel!=null && !loaded){
      initData();
    }
  }
  Widget listView() {
    return ListView.separated(
     // shrinkWrap: true,
      padding: EdgeInsets.only(left: 0.0,top: 0.0,right: 0.0,bottom: 8.0),
      itemBuilder: (context, index) =>
          buildItemLastMessage(context,userModel, listMessage[index],languageCode),
      itemCount: listMessage.length == 0 ? 0 : listMessage.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,height: 0.5,
          indent: 60.0,// padding left
          endIndent: 0,// padding right
        );
      },
    );
  }
  initData() {
    if(userModel!=null && !loaded){
      setState(() {
        loaded =true;
      });
      getListLastMessage();
    }
    if(ProviderController(context).getReloadLastMessage()){

      getListLastMessage();
      // todo: nếu gọi provider set Data in builder thì sẽ error cảnh báo :setState() or markNeedsBuild() called during build
      // todo dùng Future.delayed Zeo để xử lý
      Future.delayed(Duration.zero, () async {
        ProviderController(context).setReloadLastMessage(false);
      });
    }
  }

  getListLastMessage() {
    lastMessageDao.getSingleLastMessage(userModel.id).then((value) {
      listMessage.clear();
      for(int i = 0; i<15;i++){
        setState(() {
          listMessage.addAll(value);
        });
      }

    });

  }
  @override
  void dispose(){
    super.dispose();
  }
}
