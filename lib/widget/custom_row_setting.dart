import 'package:flutter/material.dart';
import 'package:tchat_app/widget/text_style.dart';

class CustomRowSetting extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String icon;

  CustomRowSetting(
      {@required this.onPressed, @required this.title, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 0),
              child: Image.asset(icon, width: 16, height: 16,),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
             //   mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          title,
                          style: normalTextBlack(),
                        )),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.navigate_next,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0.5,),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
