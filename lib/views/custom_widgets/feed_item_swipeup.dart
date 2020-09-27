import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../pages/feed_item_list_page.dart';
import '../../blocs/feed_item_bloc.dart';
import '../../models/feed_item_details.dart';
import '../../views/custom_widgets/image_error_widget.dart';
import '../../utils/color_constants.dart';

//Creating the card of feed item which is added in the feed item list
class FeedtinderSwiper extends StatefulWidget {
  final List<FeedItemDetails> _feedItemDetails;
  final FeedListState _feedListState;

  FeedtinderSwiper(this._feedItemDetails, this._feedListState);

  @override
  FeedtinderSwiperState createState() => FeedtinderSwiperState();
}

class FeedtinderSwiperState extends State<FeedtinderSwiper>
    with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //_feedCategoryList(_feedCategory),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55, // 400,
            child: new TinderSwapCard(
              swipeUp: true,
              swipeDown: false,
              //orientation: AmassOrientation.BOTTOM,
              totalNum: widget._feedItemDetails.length,
              stackNum: 3,
              swipeEdge: 4.0,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.width * 1.0,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              minHeight: MediaQuery.of(context).size.width * 0.8,
              cardBuilder: (context, index) => Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        color: ColorConstants.imageBackgroundColor,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            child: Hero(
                              tag: widget._feedItemDetails[index].title,
                              child: CachedNetworkImage(
                                imageUrl:
                                widget._feedItemDetails[index].imageURL,
                                placeholder: (context, url) => Align(
                                  child: SpinKitThreeBounce(
                                    color: Theme.of(context).primaryColor,
                                    controller: AnimationController(
                                      vsync: this,
                                      duration: const Duration(milliseconds: 1200),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                ),
                                errorWidget: (context, url, error) =>
                                    ImageErrorWidget(),
                                fit: BoxFit.fill,
                              ),
                            ))),

                    // Feed Source
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 0, left: 20, right: 10),
                      child: Text(
                        widget._feedItemDetails[index].category +
                            " / " +
                            widget._feedItemDetails[index].source,
                        textAlign: TextAlign.center,
                        style:
                        TextStyle(fontSize: 14.0, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Item Title
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 5, left: 20, right: 20),
                      child: Text(
                        widget._feedItemDetails[index].title,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.display3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Fav & Share Icons
                    _createShareTab(context, index),
                  ],
                ),
              ),
              cardController: controller = CardController(),
              swipeUpdateCallback:
                  (DragUpdateDetails details, Alignment align) {
                /// Get swiping card's alignment

              },
              swipeCompleteCallback:
                  (CardSwipeOrientation orientation, int index) {
                /// Get orientation & index of swiped card!
              },
            )),
          ),
      ],
    );
  }

  // Method displays the Pub date, Fav and share icons
  Widget _createShareTab(BuildContext context, int index) {
    return Align(
      alignment: Alignment.bottomRight,
          child: IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Share.share(widget._feedItemDetails[index].link,
                  subject: widget._feedItemDetails[index].title);
            },
          )
    );
  }
}
