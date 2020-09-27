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

  //Getting the sorting type
  String get sortOrderType => _feedRepository.sortOrder;


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
                _setFeedItemFavouriteStatus();
                await filterFeedItemList(
                    _feedRepository.filterType, fromMasterFetch: true);
                if (_feedRepository.feedItemList.length > 0) {
                  sortFeedItemList(_feedRepository.sortOrder);
                } else {
                  _feedItemListStreamController.sink.addError(
                      Constants.NO_FEEDS_AFTER_FILTERING);
                }
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

  //Setting the feed item as favourite
  void setFavourite(int itemIndex) {
    List<FeedItemDetails> feedItemList =
        _feedRepository.setFeedAsFavourite(itemIndex);
    //Updating th stream with latest feed item details
       _feedItemListStreamController.sink.add(feedItemList);
  }

  //Getting the favourite list of feed items
  void populateFavouriteList() async {
    Future.delayed(Duration(milliseconds: 5), ()
    {
      _favouriteListStreamController.sink.add(
          _feedRepository.populateFavouriteList());
    });
  }

  void removeFavouriteFeed(int index){
    List<FeedItemDetails> favList = List<FeedItemDetails>();
    favList = _feedRepository.removeFavouriteFeed(index);
    _favouriteListStreamController.sink.add(favList);
  }

  //Sorting the feed items based on title(ascending/descending)
  sortFeedItemList(String sortOrder){
    _feedRepository.sortFeedItemList(sortOrder).then((feedItemList){
      _feedItemListStreamController.sink.add(feedItemList);
    });


  }

  //Filtering the feed item list based on the filter condition
  filterFeedItemList(String filterData,{bool fromMasterFetch = false}){
    if(fromMasterFetch){
      _feedRepository.filterFeedItemList(filterData);
    }else {
      List<FeedItemDetails> feedItemDetails = List<FeedItemDetails>();
      Future.delayed(Duration(milliseconds: 5), () {
        feedItemDetails = _feedRepository.filterFeedItemList(filterData);
        if(feedItemDetails.length>0) {
          _feedItemListStreamController.sink.add(feedItemDetails);
        }else{
          _feedItemListStreamController.sink.addError(Constants.NO_FEEDS_AFTER_FILTERING);
        }
      });
    }
  }

  //Setting the favourite status of feed item if the item is already present in favourite list
  _setFeedItemFavouriteStatus(){

    FeedItemDetails feedItem;
    for (var i = 0; i < _feedRepository.feedItemList.length; ++i) {
      feedItem = _feedRepository.feedItemList[i];
      if(_feedRepository.favouriteItemList.where((favouriteItem) =>
      (favouriteItem.category == feedItem.category &&
          favouriteItem.title == feedItem.title && favouriteItem.isFavourite)).toList().length > 0 ){
        _feedRepository.feedItemList[i].isFavourite = true;
      }else{
        _feedRepository.feedItemList[i].isFavourite = false;
      }

    }
  }

  //Disposing the StreamControllers
  dispose() {
    print("Disposing FeedBloc");
    _feedItemListStreamController.close();
    _favouriteListStreamController.close();
  }



}
