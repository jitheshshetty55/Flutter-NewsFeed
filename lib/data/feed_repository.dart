import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/feed_api_provider.dart';
import '../models/feed_item_details.dart';
import '../models/feed_category.dart';
import '../models/feed.dart';
import '../utils/constants.dart';

//Repository used for providing data to FeedBloc
class FeedRepository with Constants {
  //instance of FeedRepository for Singleton pattern
  static final FeedRepository _instance = FeedRepository._internalFeedRepo();

  FeedsAPIProvider _feedsAPIProvider;

  //List keeping all of the feed items
  List<FeedItemDetails> _feedItemList;
  //List keeping filtered feed items
  List<FeedItemDetails> _filteredItemList;
  //List keeping favourite feed items
  List<FeedItemDetails> _favouriteItemList;
  //List keeping the feed data used for loading the feed item list
  List<Feed> _feedList;
  //SharedPreference storage for keeping the app state
  SharedPreferences _storage;

  //creating singleton of FeedRepository
  factory FeedRepository() => _instance;

  FeedRepository._internalFeedRepo() {
    _feedsAPIProvider = FeedsAPIProvider();
    _feedItemList = List<FeedItemDetails>();


    //Storing the default data from shared preference storage
    _loadDataFromStorage();
  }

  //Getter for FeedItem list
  get feedItemList => _feedItemList;

  //Getting the favourite list
  get favouriteItemList => _favouriteItemList;

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


// -- Taking the feed object so that I can use the required feed fields.
  Future<List<FeedItemDetails>> fetchFeedItemList(Feed _sourceFeed) async {
    // return _feedsAPIProvider.fetchFeedItemList(category, url);
    return _feedsAPIProvider.fetchFeedItemList(_sourceFeed);
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

    _storeFeedList(_feedList);

    return feedResponse;
  }



  //The default values for feed list, sort order and feed details text size is stored from shared preferences
  _loadDataFromStorage() async {
    _storage = await SharedPreferences.getInstance();
    //Taking the FeedList from stored data
    _feedList = _createFeedList();
  }

  //Creating the Feed list object from the stored data
  List<Feed> _createFeedList() {
    List<Feed> feedList = List<Feed>();
    List<String> feedJSONList =
    (_storage.getStringList('feedlist') ?? List<String>());
    if (feedJSONList.length > 0)
      feedList =
          feedJSONList.map((feed) => Feed.fromJSON(json.decode(feed))).toList();

    return feedList;
  }


  //Storing the selected feeds in shared preferences
  _storeFeedList(List<Feed> feedList) async {
    List<String> feedJSONList = List<String>();
    feedList = feedList.where((feedItem) => feedItem.isSelected).toList();
    feedJSONList = feedList.map((feed) => json.encode(feed)).toList();
    await _storage.setStringList('feedlist', feedJSONList);
  }


}
