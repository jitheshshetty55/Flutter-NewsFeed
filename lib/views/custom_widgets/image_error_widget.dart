
//---------------------------------------------------------------------------------------
//    Image Error Widget
//      Used to display the widget wherever images failed to load.
//---------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class ImageErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(height: 10.0),
        Text(
          Constants.ERROR_LOADING_IMAGE_TEXT,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        )
      ],
    ));
  }
}
