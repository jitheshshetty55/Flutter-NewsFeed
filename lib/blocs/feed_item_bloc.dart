import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/feed_repository.dart';
import '../models/feed_item_details.dart';
import '../utils/constants.dart';

//BLoC used for interacting with UI and Repository
//The feed item details data is piped to UI as stream
class FeedItemBloc with Constants {

  //instance of FeedItemBloc for Singleton pattern
  static final FeedItemBloc _instance = FeedItemBloc._internalFeedItemBloc();

  //StreamController for handling the feed items details
  StreamController<List<FeedItemDetails>> _feedItemListStreamController;
  //StreamController for handling the favourite list
  StreamController<List<FeedItemDetails>> _favouriteListStreamController;

  FeedRepository _feedRepository;

  //creating singleton of FeedItemBloc
  factory FeedItemBloc() => _instance;

  FeedItemBloc._internalFeedItemBloc() {
    _feedRepository = FeedRepository();
    _feedItemListStreamController = StreamController<List<FeedItemDetails>>.broadcast();
    _favouriteListStreamController = StreamController<List<FeedItemDetails>>.broadcast();
  }

  // Getting the feed items details as stream
  Stream<List<FeedItemDetails>> get feedItemList =>
      _feedItemListStreamController.stream;

  // Getting the favourite list as stream
  Stream<List<FeedItemDetails>> get favouriteList =>
      _favouriteListStreamController.stream;

  //Fetching the feed item data from Repository and the response is passed into stream
  fetchFeedItemList() {
    int count = 0;
    try {
      if(_feedRepository.feedItemList.length > 0){
        Future.delayed(Duration(milliseconds: 5), () {
          _feedItemListStreamController.sink.add(_feedRepository.feedItemList);
        });
      }else {
        //Checking whether the _feedList has loaded the data from storage else  waiting for sometime to load feed list
        if (_feedRepository.feedList == null) {
          Future.delayed(Duration(milliseconds: 5), () {
            fetchFeedItemList();
          });
        } else if (_feedRepository.feedList.length > 0) {
          _feedRepository.feedItemList.clear();

          _feedRepository.feedList.forEach((feed) async {
            print("Fetching items for Category (${feed
                .category}) and Title: (${feed.title})");
            _feedRepository.fetchFeedItemList(feed)
                .then((feedItemList) async {
              _feedRepository.feedItemList
                  .insertAll(_feedRepository.feedItemList.length, feedItemList);

              count++;
              if (count == (_feedRepository.feedList.length)) {



              }
            });
          });
        } else {
          Future.delayed(Duration(milliseconds: 5), () {
            _feedItemListStreamController.sink.addError(
                Constants.NO_FEED_ADDED);
          });
        }
      }
    } on Exception catch (exception) {
      print(exception.toString());
      //Passing the error to stream for handling exception cases
      _feedItemListStreamController.sink
          .addError(Constants.NO_NETWORK_AVAILABLE);
      throw Exception(exception);
    }
  }

  //Refresh the feed item details
  refreshFeedItemList(){
    _feedRepository.feedItemList.clear();
    _feedItemListStreamController.sink.add(_feedRepository.feedItemList);

  }
  //Disposing the StreamControllers
  dispose() {
    print("Disposing FeedBloc");
    _feedItemListStreamController.close();
    _favouriteListStreamController.close();
  }



}
