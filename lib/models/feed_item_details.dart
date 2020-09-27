import 'package:webfeed/webfeed.dart';
import 'package:html/parser.dart';
import 'package:http_utils/http_utils.dart';
//Model class for details of items in feed list
class FeedItemDetails {
  final String title;
  final String description;
  final String imageURL;
  final String author;
  final DateTime pubDate;
  final String link;
  final String category;
  final String source;
  bool favourite = false;

  FeedItemDetails(
      {this.title,
      this.description,
      this.imageURL,
      this.author,
      this.pubDate,
      this.link,
      this.category,
      this.source,
      this.favourite=false});

  bool get isFavourite => this.favourite;

  set isFavourite(bool value) {
    this.favourite = value;
  }

  //Parsing the JSON and keeping the values
  factory FeedItemDetails.fromJSON(Map<String, dynamic> json) {
    bool isFavourite = json["favourite"] == null
        ? false
        : json["favourite"];
    DateTime publishedDate = DateUtils().parseRfc822Date(json["pubDate"]);
    return FeedItemDetails(
        title: json["title"],
        description: json["description"],
        imageURL: json["imageURL"],
        author: json["author"],
        pubDate: publishedDate,
        link:json["link"],
        category:json["category"],
        source:json["source"],
        favourite: isFavourite);
  }
  //Converting the object as JSON
  Map<String, dynamic> toJson() => {
    'title':title,
    'description':description,
    'imageURL':imageURL,
    'author':author,
    'pubDate':DateUtils().formatRfc822Date(pubDate) ,
    'link':link,
    'category':category,
    'source':source,
    'favourite':favourite
  };


  //Used for parsing and storing the FeedDetails from RSSItem
  factory FeedItemDetails.parseRSSItem(RssItem rssItem, String category,
      String feedImageURL, String feedSource) {
    String itemImageURL = rssItem?.enclosure?.url ?? "";
    if (itemImageURL.trim().length == 0) {
      var contentVal = rssItem?.content?.value ?? "";
      if (contentVal.trim().length > 0) {
        var document = parse(contentVal);
        itemImageURL =
            document.getElementsByTagName('img')[0].attributes['src'];
      }
      if (itemImageURL.trim().length == 0) {
        var thumbnails = rssItem?.media?.thumbnails?.length ?? 0;
        itemImageURL =
            thumbnails > 0 ? rssItem?.media?.thumbnails[0]?.url ?? "" : "";
      }
    }
    itemImageURL = (itemImageURL.endsWith(".svg")) ? "" : itemImageURL;

    /*var dateEnd = rssItem?.pubDate?.indexOf("+");
    if(dateEnd == -1) dateEnd = rssItem?.pubDate?.indexOf("-");
    String pubDate = rssItem?.pubDate?.substring(0, dateEnd);*/
    var descriptionEnd = rssItem?.description?.indexOf("<div");
    if (descriptionEnd == -1) descriptionEnd = rssItem?.description?.length;

    // only take the text for displaying as description and any images should go into item image
    // Parse the string to extract HTML content
    var doc = parse(rssItem.description.substring(0, descriptionEnd));
    String _parsedDescriptionText=doc.body.text;
    String _imgURLInDescription;

    var imgInHtml = doc.body.querySelector('img');
    if (imgInHtml != null){
      // print("Doc Image.. ${imgInHtml.outerHtml}");
      _imgURLInDescription=imgInHtml.attributes['src'];
      // print("_image url in Description....$_imgURLInDescription");
      // (_imgURLInDescription!=null)?print("Doc Image URL.. $_imgURLInDescription"):print("img source not found");
    }

    DateTime pubDateTime;
    try {
      pubDateTime = DateUtils().parseRfc822Date(rssItem?.pubDate)??DateTime.now();
    }catch(e){
      pubDateTime = DateTime.now();
    }

    return FeedItemDetails(
        title: rssItem.title,
        // description: rssItem.description.substring(0, descriptionEnd),
        description: _parsedDescriptionText,

        imageURL: itemImageURL.trim().length > 0
            ? (itemImageURL.replaceAll(" ", ""))
            : (_imgURLInDescription!=null)?(_imgURLInDescription.replaceAll(" ", ""))  // Else Check ImageURLin Description
            :(feedImageURL.replaceAll(" ", "")),   // Else set Feed ImageURL
        author: rssItem?.author ?? "",
        pubDate: pubDateTime,

        link: rssItem.link.replaceAll(" ", ""),
        source: feedSource,
        category: category);
  }

  //Used for parsing and storing the FeedDetails from AtomItem

  factory FeedItemDetails.parseAtomItem(AtomItem atomItem, String category,
      String atomImageURL, String feedSource) {
    //TODO Do the code for taking src of <img> from content
    String itemImageURL = "";
    return FeedItemDetails(
        title: atomItem.title,
        description: atomItem.summary,
        imageURL: itemImageURL.trim().length > 0 ? itemImageURL : atomImageURL,
        author: atomItem.authors[0].name,
        pubDate: DateUtils().parseRfc822Date(atomItem.published),
        source: feedSource,
        category: category);
  }


}
