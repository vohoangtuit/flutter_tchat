
import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';

import 'package:tchat_app/models/last_message_model.dart';
import 'package:tchat_app/screens/items/item_last_message.dart';
import 'package:tchat_app/widget/list_loading_data.dart';

class LastMessageScreen extends StatefulWidget  {
  @override
  _LastMessageScreenState createState() => _LastMessageScreenState();
}
class _LastMessageScreenState extends BaseStatefulWidget<LastMessageScreen> with AutomaticKeepAliveClientMixin<LastMessageScreen>  {
  //
  @override
//  TODO: implement wantKeepAlive
 bool get wantKeepAlive => true;
  List<LastMessageModel> listMessage = List();
  bool reloadMessage =false;
 // UserModel user;

  var load;
  @override
  Widget build(BuildContext context) {
    if(ProviderController(context).getReloadLastMessage()){
      load =reloadData();
    }
    return Container(
      child: Column(
        children: [
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
    getListLastMessage();
  }
  Widget listView() {
    if(userModel==null){
      //print('last message user null');
      //return ListLoadingData();
      return Container();
    }else{
    //  print('last message user ${userModel.id}');
      return ListView.separated(
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

  }
  reloadData() {
    if(ProviderController(context).getReloadLastMessage()){

      // todo: nếu gọi provider set Data in builder thì sẽ error cảnh báo :setState() or markNeedsBuild() called during build
      // todo dùng Future.delayed Zeo để xử lý
      Future.delayed(Duration.zero, () async {
        getListLastMessage();
        ProviderController(context).setReloadLastMessage(false);
      });
    }
  }

  getListLastMessage() async{
    if(userModel==null){
      await getAccount();
    }
    if(userModel!=null){
      await initDataBase();
      lastMessageDao.getSingleLastMessage(userModel.id).then((value) {
        listMessage.clear();
        //print('listMessage '+value.toString());
        Future.delayed(Duration.zero, () async {
          setState(() {
            listMessage.addAll(value);
          });
        });
      });
    }


  }
  @override
  void dispose(){
    super.dispose();
  }
}
