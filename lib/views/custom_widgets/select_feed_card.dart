//---------------------------------------------------------------------------------------
//    Feed Cards in Select Feed page
//      Used to display the list of Feed cards of sources under a Category.
//---------------------------------------------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../blocs/feed_category_bloc.dart';
import '../../models/feed.dart';
import '../../views/custom_widgets/image_error_widget.dart';

//Creating the card of feed item which is added in the feed item list
class FeedCard extends StatelessWidget {
  final FeedCategoryBloc _feedCategoryBloc;
  final Feed _feed;
  FeedCard(this._feedCategoryBloc, this._feed);
  @override
  Widget build(BuildContext context) {
    // Card view
    return // Gesture
        GestureDetector(
            onTap: () =>
                _feedCategoryBloc.selectFeed(_feed.category, _feed.title),
            child: Card(
              color: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
              child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              // Image
              child: Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Image
                    CachedNetworkImage(
                      imageUrl: _feed.imageURL,
                      placeholder: (context, url) => Align(
                        alignment: Alignment.centerLeft,
                      ),
                      errorWidget: (context, url, error) => ImageErrorWidget(),
                      height: MediaQuery.of(context).size.height,
                      width: 70,
                      fit: BoxFit.cover,
                    ),

                    // Title
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          _feed.title,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.display3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Tick for selection
                    Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            _feed.isSelected
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: Theme.of(context).primaryColor,
                            size: 30.0,
                          ),
                          onPressed: () {
                            _feedCategoryBloc.selectFeed(
                                _feed.category, _feed.title);
                          },
                        )),
                  ],
                ),
              ),
            ),),);
  }
}
