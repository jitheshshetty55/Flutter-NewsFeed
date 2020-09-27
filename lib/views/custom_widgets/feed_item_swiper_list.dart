import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../pages/feed_item_list_page.dart';
import '../../blocs/feed_item_bloc.dart';
import '../../models/feed_item_details.dart';
import '../../views/custom_widgets/image_error_widget.dart';
import '../../utils/color_constants.dart';

//Creating the card of feed item which is added in the feed item list
class FeedItemSwiper extends StatefulWidget {
  final List<FeedItemDetails> _feedItemDetails;
  final FeedListState _feedListState;

  FeedItemSwiper(this._feedItemDetails, this._feedListState);

  @override
  FeedItemSwiperState createState() => FeedItemSwiperState();
}

class FeedItemSwiperState extends State<FeedItemSwiper> with TickerProviderStateMixin{
  FeedItemBloc _feedItemBloc = FeedItemBloc();

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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        //_feedCategoryList(_feedCategory),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.55,// 400,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){},
                  child: Card(
                    color: Theme.of(context).backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Fav & Share Icons
                        _createShareTab(context, index),
                      ],
                    ),
                  ),
                );
              },
              onIndexChanged: (index) {},
              itemCount: widget._feedItemDetails.length,
              loop: false,
              scrollDirection: Axis.horizontal,
              viewportFraction: 0.75,
              scale: 0.8,
              duration: 5000,
            ),
          ),
        )
      ],
    );
  }

  // Method displays the Pub date, Fav and share icons
  Widget _createShareTab(BuildContext context, int index) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 5,
              child: Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(widget._feedItemDetails[index].title ,
                    style: TextStyle(color: Colors.grey, fontSize: 11.0),
                  ))),

          Expanded(
              child: IconButton(
            icon: Icon(Icons.share, color: Theme.of(context).iconTheme.color),
            onPressed: () {
              Share.share(widget._feedItemDetails[index].link,
                  subject: widget._feedItemDetails[index].title);
            },
          ))
        ],
      ),
    );
  }

}
