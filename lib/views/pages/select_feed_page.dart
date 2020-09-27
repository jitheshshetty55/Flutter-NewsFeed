//---------------------------------------------------------------------------------------
//    Select Feed Page
//      Used to display the list of Feed sources under a Category.
//---------------------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../custom_widgets/feed_item_list_top_bar.dart';
import '../custom_widgets/select_feed_card.dart';
import '../../blocs/feed_category_bloc.dart';
import '../../blocs/feed_item_bloc.dart';
import '../../models/feed.dart';
import '../../utils/constants.dart';
import '../custom_widgets/alert_message_view.dart';

class SelectFeed extends StatefulWidget {
  final String _categoryName;
  SelectFeed(this._categoryName);

  @override
  State<StatefulWidget> createState() {
    return _SelectFeedState();
  }
}

class _SelectFeedState extends State<SelectFeed>
    with TickerProviderStateMixin, Constants {
  FeedCategoryBloc _feedCategoryBloc = FeedCategoryBloc();

  @override
  void initState() {
    _feedCategoryBloc.fetchFeedByCategory(widget._categoryName);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //Top Bar
          TopBar(
            height: 200,
            shapeColor: Theme.of(context).primaryColor,
          ),
          // Category Name
          Padding(
            padding: EdgeInsets.only(left: 15, top: 150),
            child: Hero(
              tag: widget._categoryName,
              child: Text(
                widget._categoryName,
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ),
          // Feed Source List
          Padding(
            padding: EdgeInsets.only(top: 200),
            child: StreamBuilder(
              stream: _feedCategoryBloc.feedData,
              builder: (context, AsyncSnapshot<List<Feed>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: _buildFeedList(snapshot.data),
                    height: MediaQuery.of(context).size.height * 0.7,
                  );
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
                    ));
              },
            ),
          ),
          // App Baar
          Container(
            height: 200,
            child: AppBar(
              title: Text(
                Constants.SELECT_FEED_HEADER,
                style: Theme.of(context).textTheme.title,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {
                  _feedCategoryBloc.currentSelectedTab = 1;
                  Navigator.of(context).pop();
                  FeedItemBloc().refreshFeedItemList();
                },
              ),],
            ),
          ),
        ],
      ),
    );
  }

  // Method returns the Listview of Feedcards
  ListView _buildFeedList(List<Feed> feedList) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 5),
      itemCount: feedList.length,
      itemBuilder: (BuildContext context, int index) {
        return FeedCard(_feedCategoryBloc, feedList[index]);
      },
    );
  }
}
