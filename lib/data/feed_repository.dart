import 'dart:async';
import 'dart:convert';
import '../data/feed_api_provider.dart';
import '../models/feed_category.dart';
import '../models/feed.dart';
import '../utils/constants.dart';

//Repository used for providing data to FeedBloc
class FeedRepository with Constants {
  //instance of FeedRepository for Singleton pattern
  static final FeedRepository _instance = FeedRepository._internalFeedRepo();

  FeedsAPIProvider _feedsAPIProvider;

  //List keeping the feed data used for loading the feed item list
  List<Feed> _feedList;



  //creating singleton of FeedRepository
  factory FeedRepository() => _instance;

  FeedRepository._internalFeedRepo() {
    _feedsAPIProvider = FeedsAPIProvider();

  }


  //Returning the list of selected feeds for populating the feed details
  get feedList => _getFeedList();

  //Checking whether the _feedList is null else only selected feeds returned
  List<Feed> _getFeedList() {
    if (_feedList != null) {
      return _feedList.where((feed) => feed.isSelected)?.toList() ??
          List<Feed>();
    } else {
      return _feedList;
    }
  }


  //Using the fetchFeedCategories of FeedsAPIProvider feed categories are fetched for the given url
  Future<List<FeedCategory>> fetchFeedCategories() =>
      _feedsAPIProvider.fetchFeedCategories();

  //Using the fetchFeedsByCategory of FeedsAPIProvider all the feeds under a category is fetched for the given url
  Future<List<Feed>> fetchFeedsByCategory(String category) async {
    List<Feed> feedResponse;

    feedResponse = await _feedsAPIProvider.fetchFeedsByCategory(category);

    Feed newFeed;
    for (var i = 0; i < feedResponse.length; ++i) {
      newFeed = feedResponse[i];

      if (_feedList
          .where((feed) => (feed.category == newFeed.category &&
          feed.title == newFeed.title &&
          feed.isSelected))
          .toList()
          .length >
          0) {
        feedResponse[i].isSelected = true;
      } else {
        feedResponse[i].isSelected = false;
      }
    }

    _feedList.removeWhere((feed) => feed.category == category);
    _feedList.insertAll(_feedList.length, feedResponse);

    return feedResponse;
  }

  //Checking the feed as selected from add feed
  Future<List<Feed>> selectFeed(String category, String title) async {
    List<Feed> feedResponse = List<Feed>();

    _feedList.forEach((feed) {
      if (feed.category == category) {
        if (feed.title == title) {
          feed.isSelected = !feed.isSelected;
        }
        feedResponse.add(feed);
      }
    });

    return feedResponse;
  }

}
