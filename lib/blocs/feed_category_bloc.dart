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


  //StreamController for handling the feed categories
  StreamController<List<FeedCategory>> _feedCategoryStreamController;


  //StreamController for handling the current selected Tab in app
  StreamController<int> _currentTabStreamController;

  //creating singleton of FeedCategoryBloc
  factory FeedCategoryBloc() => _instance;

  FeedCategoryBloc._internalFeedCategoryBloc() {
    _feedRepository = FeedRepository();
    _feedCategoryStreamController =
        StreamController<List<FeedCategory>>.broadcast();
    _currentTabStreamController = StreamController<int>.broadcast();
  }


  // Getting the feed items details as stream from _feedCategoryStreamController
  Stream<List<FeedCategory>> get feedCategories =>
      _feedCategoryStreamController.stream;


  //Getting the value of current selected Tab in app as stream
  get currentSelectedTab => _currentTabStreamController.stream;



  //Setting the value of current selected Tab in app
  set currentSelectedTab(value) => _currentTabStreamController.sink.add(value);



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



  //Disposing the StreamControllers
  dispose() {
    print("Disposing FeedCategoryBloc");
    _feedCategoryStreamController.close();
    _currentTabStreamController.close();
  }
}
