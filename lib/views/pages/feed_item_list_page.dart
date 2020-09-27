//---------------------------------------------------------------------------------------
//    Feed Item List Page
//      This page list the feed items from the selected feed source. This is the page
//      that appears when the user taps on Home Icon button in the bottom tab bar.
//---------------------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/feed_item_details.dart';
import '../../blocs/feed_item_bloc.dart';
import '../custom_widgets/arched_top_bar.dart';
import '../custom_widgets/mode_menu.dart';
import '../../utils/constants.dart';
import '../custom_widgets/alert_message_view.dart';


class FeedItemList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FeedListState();
  }
}

class FeedListState extends State<FeedItemList>
    with TickerProviderStateMixin, Constants {
  FeedItemBloc _feedBloc = FeedItemBloc();
  final ModeMenu modeMenu = ModeMenu();

  @override
  void initState() {
    _feedBloc.fetchFeedItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Current FeedList view ... ${modeMenu.getCurrentFeedListView()}");
    modeMenu.setFeedListState(this);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Scrollbar(
              child: SingleChildScrollView(
                // Stack Layout
                  child: Stack(
                    children: <Widget>[
                      // Page Top Arch
                      ArchedTopBar(
                        height: 400,
                        shapeColor: Theme.of(context).primaryColor,
                      ),
                      // Column Layout
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //FeedList in selected mode
                          Padding(
                            padding: EdgeInsets.only(
                                top: (modeMenu.getCurrentFeedListView() ==
                                    Constants.MODE_MENU_CAROUSAL)
                                    ? 180
                                    : 150),
                            child: Container(
                                height: MediaQuery.of(context).size.height *
                                    ((modeMenu.getCurrentFeedListView() ==
                                        Constants.MODE_MENU_CAROUSAL)
                                        ? 0.60
                                        : 0.76),
                                child: StreamBuilder(
                                  stream: _feedBloc.feedItemList,
                                  builder: (context,
                                      AsyncSnapshot<List<FeedItemDetails>> snapshot) {
                                    if (snapshot.hasData && snapshot.data.length > 0) {
                                      modeMenu.setFeedItemData(snapshot.data);
                                      return modeMenu.loadFeedItemView();
                                    } else if (snapshot.hasError) {
                                      // No data alert view
                                      modeMenu.setFeedItemData(null);
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                            child: AlertView(
                                                snapshot.error.toString(), false),
                                          ),

                                      );
                                    }else{
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: AlertView(
                                              Constants.NO_FEED_ADDED, false),
                                        ),

                                      );
                                    }
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        child: AlertView(
                                            Constants.NO_FEED_ADDED, false),
                                      ),

                                    );
                                  },
                                )),
                          ),
                        ],
                      ),
                      // App bar
                      Container(
                        height: 100,
                        child: AppBar(
                          leading: new Container(),
                          title: Text(Constants.APP_TITLE),
                          centerTitle: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: <Widget>[
                            //--- Refresh Icon
                            IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _feedBloc.refreshFeedItemList();
                                Future.delayed(Duration(milliseconds: 10), () {
                                  _feedBloc.fetchFeedItemList();
                                });
                              },
                            ),
                            //--- Feed Speak Icon

                          ],
                        ),
                      ),
                      // Mode Menu
                      Center(
                        child: SizedBox(
                          height: 280,
                          width: 300,
                          child: modeMenu,
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
