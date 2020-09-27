import 'dart:async';
import '../data/feed_repository.dart';
import '../models/feed_category.dart';
import '../models/feed.dart';
import '../utils/constants.dart';


//BLoC used for interacting with UI and Repository
//The data for Feed category and Feed is piped to UI as stream
class FeedCategoryBloc with Constants{
  //instance of FeedCategoryBloc for Singleton pattern
  static final FeedCategoryBloc _instance =
  FeedCategoryBloc._internalFeedCategoryBloc();

  FeedRepository _feedRepository;
  //StreamController for handling the feed details
  StreamController<List<Feed>> _feedStreamController;

  //StreamController for handling the feed categories
  StreamController<List<FeedCategory>> _feedCategoryStreamController;

  //StreamController for handling the feed details
  StreamController<List<String>> _selectedCategoryStreamController;

  //StreamController for handling the current selected Tab in app
  StreamController<int> _currentTabStreamController;

  //creating singleton of FeedCategoryBloc
  factory FeedCategoryBloc() => _instance;

  FeedCategoryBloc._internalFeedCategoryBloc() {
    _feedRepository = FeedRepository();
    _feedStreamController = StreamController<List<Feed>>.broadcast();
    _feedCategoryStreamController =
    StreamController<List<FeedCategory>>.broadcast();
    _selectedCategoryStreamController =
    StreamController<List<String>>.broadcast();
    _currentTabStreamController = StreamController<int>.broadcast();
  }


  // Getting the feed items details as stream from _feedStreamController
  Stream<List<Feed>> get feedData => _feedStreamController.stream;

  // Getting the feed items details as stream from _feedCategoryStreamController
  Stream<List<FeedCategory>> get feedCategories =>
      _feedCategoryStreamController.stream;

  // Getting the selected categories as stream from _selectedCategoryStreamController
  Stream<List<String>> get selectedCategories =>
      _selectedCategoryStreamController.stream;

  //Getting the value of current selected Tab in app as stream
  get currentSelectedTab => _currentTabStreamController.stream;

  //Fetching the all the feeds coming under a category and the response is passed into stream
  fetchFeedByCategory(String category) async {
    try {
      List<Feed> feedList =
      await _feedRepository.fetchFeedsByCategory(category);
      if(feedList.length > 0) {
        _feedStreamController.sink.add(feedList);
      }else{
        _feedStreamController.sink.addError(Constants.NO_FEEDS_UNDER_CATEGORY);
      }
    } on Exception catch (exception) {
      //Passing the error to stream for handling exception cases
      _feedStreamController.sink.addError(Constants.NO_NETWORK_AVAILABLE);
      throw Exception(exception);
    }
  }

  //Setting the value of current selected Tab in app
  set currentSelectedTab(value) => _currentTabStreamController.sink.add(value);

  //Selecting the feeds that should be displayed in dashboard
  selectFeed(String category, String title) async {
    try {
      List<Feed> feedList = await _feedRepository.selectFeed(category, title);
      //Updating the stream with updated feed list
      _feedStreamController.sink.add(feedList);
      //Updating the _selectedCategoryStreamController to get the latest data in stream
      fetchSelectedFeedCategories();
    } on Exception catch (exception) {
      //Passing the error to stream for handling exception cases
      _feedStreamController.sink.addError(Constants.NO_NETWORK_AVAILABLE);
      throw Exception(exception);
    }
  }

  //Fetching the feed categories from Repository and the response is passed into stream
  fetchFeedCategories() {
    try {
      _feedRepository.fetchFeedCategories().then((categories) {
        //Updating th stream with latest feed categories
        if (categories.length > 0) {
          _feedCategoryStreamController.sink.add(categories);
        } else {
          //Updating the stream with error that no categories are added.
          _feedCategoryStreamController.sink
              .addError(Constants.NO_CATEGORIES_ADDED);
        }
      });
    } on Exception catch (exception) {
      //Passing the error to stream for handling exception cases
      _feedCategoryStreamController.sink
          .addError(Constants.NO_NETWORK_AVAILABLE);
      throw Exception(exception);
    }
  }

  //Fetching the feed categories that already have one feed as selected
  fetchSelectedFeedCategories() {
    try {
      List<String> selectedCategoryList = List<String>();
      //Checking whether the _feedList has loaded the data from storage else  waiting for sometime to load feed list
      if (_feedRepository.feedList == null) {
        Future.delayed(Duration(milliseconds: 5), () {
          fetchSelectedFeedCategories();
        });
      } else if (_feedRepository.feedList.length > 0) {
        _feedRepository.feedList.forEach((feed) async {
          if ((!selectedCategoryList.contains(feed.category))) {
            selectedCategoryList.add(feed.category);
          }
        });

      }
      _selectedCategoryStreamController.sink.add(selectedCategoryList);
    } on Exception catch (exception) {
      //Passing the error to stream for handling exception cases
      _selectedCategoryStreamController.sink
          .addError(Constants.NO_NETWORK_AVAILABLE);
      throw Exception(exception);
    }
  }

  //Disposing the StreamControllers
  dispose() {
    print("Disposing FeedCategoryBloc");
    _feedStreamController.close();
    _feedCategoryStreamController.close();
    _selectedCategoryStreamController.close();
    _currentTabStreamController.close();
  }
}
