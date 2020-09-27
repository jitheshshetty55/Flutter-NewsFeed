//Constants used in the application
mixin Constants {
  static const APP_TITLE = "News Point";
  static const FEED_BASE_API =
      "https://firestore.googleapis.com/v1/projects/feedzone-2422a/databases/(default)/documents/";

  static const FEED_CATEGORY = "Category";

  static const NETWORK_TIMEOUT_SECONDS = 30;

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

}
