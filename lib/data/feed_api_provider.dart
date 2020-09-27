import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart';
import '../models/feed_item_details.dart';
import '../models/feed_category.dart';
import '../models/feed.dart';
import '../utils/constants.dart';

// Class used for providing data from server for all feed related objects
class FeedsAPIProvider with Constants {
  //Fetching the feed data for the given url
  // Future<List<FeedItemDetails>> fetchFeedItemList(String category, String url) async {
  Future<List<FeedItemDetails>> fetchFeedItemList(Feed sourceFeed) async {
    var url = sourceFeed.link;
    var category = sourceFeed.category;
    var feedSource = sourceFeed.title;

    print("Calling URL : $url");
    http.Response response = await http
        .get(url)
        .timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),onTimeout:()=>throw Exception);

    if (response.statusCode == 200) {
      List<FeedItemDetails> feedItemList = List<FeedItemDetails>();

      switch (_getFeedType(response.body)) {
        case Constants.FEED_TYPE_RSS:
          {
            //Parsing the RSS feed from the response
            RssFeed rssFeed = RssFeed.parse(response.body);
            //Keeping the image of feed for adding in FeedItemDetails,
            String rssImageURL = rssFeed.image == null ? "" : rssFeed.image.url;
            feedItemList = rssFeed.items
                .map((item) => FeedItemDetails.parseRSSItem(
                item, category, rssImageURL, feedSource))
                .toList();
          }
          break;
        case Constants.FEED_TYPE_ATOM:
          {
            //Parsing the RSS feed from the response
            AtomFeed atomFeed = AtomFeed.parse(response.body);
            //Keeping the logo of feed for adding in FeedItemDetails,
            String atomImageURL = atomFeed.logo == null ? "" : atomFeed.logo;
            feedItemList = atomFeed.items
                .map((item) => FeedItemDetails.parseAtomItem(
                item, category, atomImageURL, feedSource))
                .toList();
          }
          break;
        default:
          {
            throw Exception(Constants.INVALID_FEED_DATA);
          }
      }
      return feedItemList;
    } else {
      // If service call was not successful, throw an error.
      throw Exception(Constants.INVALID_RESPONSE);
    }
  }

  //Fetching the feed categories from fire store
  Future<List<FeedCategory>> fetchFeedCategories() async {
    http.Response response = await http
        .get(Constants.FEED_BASE_API + Constants.FEED_CATEGORY)
        .timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),onTimeout:()=>throw Exception);

    if (response.statusCode == 200) {
      if (response.body.toString().trim().length > 2) {
        //Decoding and parsing the json to FeedCategory model
        var responseData = jsonDecode(response.body);
        var documents = responseData["documents"] as List;
        return documents
            .map((document) => FeedCategory.fromJSON(document))
            .toList();
      } else {
        return List<FeedCategory>();
      }
    } else {
      // If service call was not successful, throw an error.
      throw Exception(Constants.INVALID_RESPONSE);
    }
  }

  //Fetching the List of feeds from fire store based on categories
  Future<List<Feed>> fetchFeedsByCategory(String category) async {
    final String url =
    (Constants.FEED_BASE_API + "Category/" + category + "/" + category);

    print(url);

    http.Response response = await http
        .get(url)
        .timeout(Duration(seconds: Constants.NETWORK_TIMEOUT_SECONDS),onTimeout:()=>throw Exception);
    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.toString().trim().length > 2) {
        //Decoding and parsing the json to Feed model
        var responseData = jsonDecode(response.body);
        var documents = responseData["documents"] as List;
        return documents.map((document) => Feed.fromJSON(document)).toList();
      } else {
        return List<Feed>();
      }
    } else {
      // If service call was not successful, throw an error.
      throw Exception(Constants.INVALID_RESPONSE);
    }
  }


  //Return whether the given response is a valid RSS or Atom feed
  int _getFeedType(response) {
    var document = parse(response);
    int feedType = 0;
    if (document.getElementsByTagName('rss').length > 0) {
      feedType = Constants.FEED_TYPE_RSS;
    } else if (document.getElementsByTagName('feed').length > 0) {
      feedType = Constants.FEED_TYPE_ATOM;
    }
    return feedType;
  }
}
