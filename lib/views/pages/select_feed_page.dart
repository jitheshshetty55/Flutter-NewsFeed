//---------------------------------------------------------------------------------------
//    Select Feed Page
//      Used to display the list of Feed sources under a Category.
//---------------------------------------------------------------------------------------

import 'package:flutter/material.dart';


class SelectFeed extends StatefulWidget {
  final String _categoryName;
  SelectFeed(this._categoryName);

  @override
  State<StatefulWidget> createState() {
    return _SelectFeedState();
  }
}

class _SelectFeedState extends State<SelectFeed> {


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container()
      );
  }

}
