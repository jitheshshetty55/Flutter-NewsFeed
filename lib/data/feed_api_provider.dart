import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feed_category.dart';
import '../utils/constants.dart';


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


