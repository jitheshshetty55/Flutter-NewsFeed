//Model class used for feed
class Feed {
  final String category;
  final String title;
  final String description;
  final String imageURL;
  final String link;
  bool selectedFeed = false;

  Feed(
      {this.category,
      this.title,
      this.description,
      this.imageURL,
      this.link,
      this.selectedFeed = false});

  //Parsing the JSON and keeping the values
  factory Feed.fromJSON(Map<String, dynamic> json) {
    bool selectedFeedvalue = json["fields"]["selectedFeed"] == null
        ? false
        : json["fields"]["selectedFeed"]["stringValue"];
    return Feed(
        category: json["fields"]["categoryname"]["stringValue"],
        title: json["fields"]["title"]["stringValue"],
        description: json["fields"]["description"]["stringValue"],
        imageURL: json["fields"]["imageurl"]["stringValue"],
        link: json["fields"]["source"]["stringValue"],
        selectedFeed: selectedFeedvalue);
  }
  //Converting the object as JSON
  Map<String, dynamic> toJson() => {
        'fields': {
          'categoryname': {'stringValue': category},
          'title': {'stringValue': title},
          'description': {'stringValue': description},
          'imageurl': {'stringValue': imageURL},
          'source': {'stringValue': link},
          'selectedFeed': {'stringValue': selectedFeed}
        }
      };

  bool get isSelected => this.selectedFeed;

  set isSelected(bool val) {
    this.selectedFeed = val;
  }
}
