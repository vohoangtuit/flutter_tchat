import 'package:flutter/material.dart';
import 'package:tchat_app/screens/items/item_loading_data.dart';
class ListLoadingData extends StatelessWidget {
  const ListLoadingData();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.only(left: 0.0,top: 0.0,right: 0.0,bottom: 8.0),
      itemBuilder: (context, index) => buildItemLoadingData(context),
      itemCount: 5,
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