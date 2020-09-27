
//Model class used for feed categories
class FeedCategory {
  //final int categoryID;
  final String name;
  final String description;
  final String imageURL;
  bool _isSelected = false;


  FeedCategory({/*this.categoryID,*/ this.name, this.description, this.imageURL});

  //Parsing the JSON and keeping the values
  factory FeedCategory.fromJSON(Map<String, dynamic> json) {
   // print(json["fields"]["categoryid"]["integerValue"]);
    return FeedCategory(
       // categoryID: json["fields"]["categoryid"]["integerValue"],
        name: json["fields"]["name"]["stringValue"],
        description: json["fields"]["description"]["stringValue"],
        imageURL: json["fields"]["imageurl"]["stringValue"]

    );
  }

}