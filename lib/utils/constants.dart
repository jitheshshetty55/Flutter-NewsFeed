//Constants used in the application
mixin Constants {
  static const APP_TITLE = "News Point";
  static const FEED_BASE_API =
      "https://firestore.googleapis.com/v1/projects/feedzone-2422a/databases/(default)/documents/";

  static const FEED_CATEGORY = "Category";
  static const TEMP_FEED_URL =
      "http://feeds.reuters.com/reuters/technologyNews";
  static const NETWORK_TIMEOUT_SECONDS = 30;
  static const FEED_TYPE_RSS = 1;
  static const FEED_TYPE_ATOM = 2;
  static const INVALID_RESPONSE = "Invalid response from server";
  static const NO_NETWORK_AVAILABLE =
      "No network available. Please check the internet connectivity.";
  static const INVALID_FEED_DATA =
      "The response is not a valid RSS or Atom Feed";

  static const FEED_TAB_ADD = "Add";
  static const FEED_TAB_HOME = "Home";


  static const FEED_LIST_HEADER = "Category";
   static const FEED_LIST_DEFAULT_CATEGORY = "Technology";

  static const ADD_FEED_HEADER = "Add Feed";
  static const ADD_FEED_SUB_HEADER = "Categories";

  static const SELECT_FEED_HEADER = "Select Feed";

  static const NO_CATEGORIES_ADDED =
      "No categories added. You have to add categories from $APP_TITLE Web Admin app.";
  static const NO_FEEDS_UNDER_CATEGORY =
      "No feeds available under the selected category. You have to add feeds from $APP_TITLE Web Admin app.";
  static const NO_FEED_ADDED =
      "You have to add a feed for showing the details. Feeds can be added from Add Feed.";
  static const NO_FEED_TO_PLAY =
      "You dont have any feeds to play. Please add the feeds using Add Feed option.";
  static const NO_FEEDS_AFTER_FILTERING =
      "No feeds available for display. Please check the filter condition.";

  // Added By: Jithesh - Minimum Screen Size constants for different screens
  static const SCREEN_SIZE_DESKTOP = 1100;
  static const SCREEN_SIZE_TABLET = 600;
  static const SCREEN_SIZE_MOBILE = 300;


  static const String ERROR_LOADING_IMAGE_TEXT = "Failed to Load the Image";
  static const STORAGE_LOAD_ERROR = "Error while opening the storage";

}
