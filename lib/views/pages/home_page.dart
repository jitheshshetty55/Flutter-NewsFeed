import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../pages/feed_item_list_page.dart';
import '../pages/category_list.dart';
import '../../blocs/feed_category_bloc.dart';

//Home screen used for handling bottom tab navigation
class HomeScreen extends StatelessWidget {
  final List<Widget> _bottomTabWidgetList = List<Widget>();
  final FeedCategoryBloc _feedCategoryBloc = FeedCategoryBloc();
  final FeedItemList _feedItemList = FeedItemList();

  HomeScreen() {
    _feedCategoryBloc.currentSelectedTab = 1;
    _bottomTabWidgetList.add(AddFeed());
    _bottomTabWidgetList.add(_feedItemList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
          stream: _feedCategoryBloc.currentSelectedTab,
          initialData: 1,
          builder: (context, AsyncSnapshot<int> snapshot) {
            print("Tab : ${snapshot.data}");
            return _bottomTabWidgetList[snapshot.data];
          }),
      bottomNavigationBar:  StreamBuilder(
          stream: _feedCategoryBloc.currentSelectedTab,
          initialData: 1,
          builder: (context, AsyncSnapshot<int> snapshot) {
            return _createBottomNavBar(context, snapshot.data);
          }),
    );
  }

  Container _createBottomNavBar(BuildContext context, int position) {
    return Container(
      height: 70,
      color: Theme.of(context).primaryColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CurvedNavigationBar(
          index: position,
          height: 55.0,
          color: Theme.of(context).backgroundColor,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          items: <Widget>[
            Icon(Icons.add, size: 30),
            Icon(Icons.home, size: 30),
          ],
          onTap: (index) {
            _feedCategoryBloc.currentSelectedTab = index;
          },
        ),
      ),
    );
  }



}
