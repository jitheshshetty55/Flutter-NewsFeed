//---------------------------------------------------------------------------------------
//    Add Feed Page
//      Used to display the list of Feed Categories.
//---------------------------------------------------------------------------------------

import '../../views/custom_widgets/image_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../custom_widgets/feed_item_list_top_bar.dart';
import '../../blocs/feed_category_bloc.dart';
import '../../models/feed_category.dart';
import '../pages/select_feed_page.dart';
import '../../utils/constants.dart';
import '../custom_widgets/alert_message_view.dart';

class AddNews extends StatefulWidget {
  AddNews();

  @override
  State<StatefulWidget> createState() {
    return _AddNewsState();
  }
}

class _AddNewsState extends State<AddNews>
    with TickerProviderStateMixin, Constants {
  FeedCategoryBloc _feedCategoryBloc = FeedCategoryBloc();

  @override
  void initState() {
    _feedCategoryBloc.fetchFeedCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Top bar
          TopBar(
            height: 200,
            shapeColor: Theme.of(context).primaryColor,
          ),
          // Categories Header
          Padding(
              padding: EdgeInsets.only(top: 150, left: 15),
              child: Text(
                Constants.ADD_FEED_SUB_HEADER,
                style: Theme.of(context).textTheme.subtitle,
              )),

          //Grid View of Categories
          Padding(
            padding: EdgeInsets.only(top: 180),
            child: StreamBuilder(
              stream: _feedCategoryBloc.feedCategories,
              builder: (context, AsyncSnapshot<List<FeedCategory>> snapshot) {
                if (snapshot.hasData) {
                  return _buildCategoryList(snapshot.data);
                } else if (snapshot.hasError) {
                  return Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: AlertView(snapshot.error.toString(), false),
                      ));
                }
                return Align(
                  alignment: Alignment.center,
                  child: SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
                    controller: AnimationController(
                      vsync: this,
                      duration: const Duration(milliseconds: 1200),
                    ),
                  ),
                );
              },
            ),
          ),
          // App bar
          Container(
            height: 100,
            child: AppBar(
              leading: new Container(),
              title: Text(
                Constants.ADD_FEED_HEADER,
                style: Theme.of(context).textTheme.title,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

// Method creates the GridView of categories
  Widget _buildCategoryList(List<FeedCategory> feedCategories) {
    return Container(
      // Grid View
      child: GridView.builder(
          itemCount: feedCategories.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                //print(index);
                _navigateToSelectFeed(context,feedCategories[index].name);
              },
              child: Hero(
                tag: feedCategories[index].name,
                // Card for each category
                child: Card(
                  color: Theme.of(context).backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // Column
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          // Category Image
                          child: CachedNetworkImage(
                              imageUrl: feedCategories[index].imageURL,
                              errorWidget: (context, url, err) =>
                                  ImageErrorWidget(),
                              height: MediaQuery.of(context).size.height ,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover),
                        ),
                        // Category Title
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 10),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Align(alignment: Alignment.center, child:Text(
                            feedCategories[index].name,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.display3,
                          ),) ,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void _navigateToSelectFeed(BuildContext context, String categoryName) {
    Navigator.of(context).push(
      PageRouteBuilder<String>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SelectFeed(categoryName);
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}
