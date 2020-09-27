import 'dart:async';
import 'dart:convert';
import '../data/feed_api_provider.dart';
import '../models/feed_category.dart';
import '../data/feed_api_provider.dart';

//Repository used for providing data to FeedBloc
class FeedRepository {
  //instance of FeedRepository for Singleton pattern
  static final FeedRepository _instance = FeedRepository._internalFeedRepo();

  FeedsAPIProvider _feedsAPIProvider;


  //creating singleton of FeedRepository
  factory FeedRepository() => _instance;

  FeedRepository._internalFeedRepo() {
    _feedsAPIProvider = FeedsAPIProvider();



  }



  //Using the fetchFeedCategories of FeedsAPIProvider feed categories are fetched for the given url
  Future<List<FeedCategory>> fetchFeedCategories() =>
      _feedsAPIProvider.fetchFeedCategories();

}
