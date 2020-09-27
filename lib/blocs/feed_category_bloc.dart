import 'dart:async';


//BLoC used for interacting with UI and Repository
//The data for Feed category and Feed is piped to UI as stream
class FeedCategoryBloc {
  //instance of FeedCategoryBloc for Singleton pattern
  static final FeedCategoryBloc _instance =
      FeedCategoryBloc._internalFeedCategoryBloc();


  //StreamController for handling the current selected Tab in app
  StreamController<int> _currentTabStreamController;

  //creating singleton of FeedCategoryBloc
  factory FeedCategoryBloc() => _instance;

  FeedCategoryBloc._internalFeedCategoryBloc() {
    _currentTabStreamController = StreamController<int>.broadcast();
  }



  //Setting the value of current selected Tab in app
  set currentSelectedTab(value) => _currentTabStreamController.sink.add(value);

  //Getting the value of current selected Tab in app as stream
  get currentSelectedTab => _currentTabStreamController.stream;


  //Disposing the StreamControllers
  dispose() {
    print("Disposing FeedCategoryBloc");
    _currentTabStreamController.close();
  }
}
