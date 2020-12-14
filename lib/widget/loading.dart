import 'package:flutter/material.dart';

import '../utils/const.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
        ),
      ),
      color: Colors.white.withOpacity(0.8),
    );
  }
}
