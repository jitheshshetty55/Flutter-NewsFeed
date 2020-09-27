//---------------------------------------------------------------------------------------
//    Feed Item List Page
//      This page list the feed items from the selected feed source. This is the page
//      that appears when the user taps on Home Icon button in the bottom tab bar.
//---------------------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FeedItemList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedListState();
  }
}

class FeedListState extends State<FeedItemList> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
         ),
    );
  }
}
