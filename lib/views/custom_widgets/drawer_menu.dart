import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer/hidden_drawer_menu.dart';
import '../../blocs/feed_category_bloc.dart';
import '../../blocs/feed_item_bloc.dart';
import '../../utils/constants.dart';

class DrawerMenu extends StatefulWidget {
  final String _selectedFilter;

  DrawerMenu(this._selectedFilter);
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}
class _DrawerMenuState extends State<DrawerMenu> {
  FeedCategoryBloc _feedCategoryBloc = FeedCategoryBloc();

  @override
  void initState() {
    _feedCategoryBloc.fetchSelectedFeedCategories();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        //color: Theme.of(context).backgroundColor,
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            // stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Theme.of(context).primaryColor,
              Theme.of(context).backgroundColor,
            ],
          ),
        ),
        //padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 80),
              child: _createFeedCategory(context),
            ),

          ],
        ));
  }

  Container _createFeedCategory(BuildContext context) => Container(
    width: MediaQuery.of(context).size.width * 0.75,
    height: MediaQuery.of(context).size.height * 0.55,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 200,
            height: 50,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
            ),
            child: Text(
              Constants.FILTER_OPTION,
              style: Theme.of(context).textTheme.display2,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: StreamBuilder(
            stream: _feedCategoryBloc.selectedCategories,
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: (MediaQuery.of(context).size.height * 0.4),
                  child: /*Scrollbar(child: */ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ItemHiddenMenu(
                        name :snapshot.data[index],
                        baseStyle: Theme.of(context).textTheme.body1,
                        colorLineSelected: Theme.of(context).primaryColor,
                        selected :  (widget._selectedFilter == snapshot.data[index]) ? true :false,
                        onTap: (){
                          FeedItemBloc().filterFeedItemList(snapshot.data[index]);
                          SimpleHiddenDrawerProvider.of(context)
                              .setSelectedMenuPosition(index);

                        },

                      );
                    },
                  ),//) ,
                );
              } else {
                print("test");
                return Text(Constants.NO_FEED_ADDED,style: Theme.of(context).textTheme.display1,);
              }

            },
          ),
        ),
      ],
    ),
  );

}

