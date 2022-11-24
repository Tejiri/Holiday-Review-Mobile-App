class Location {
  late String category;
  late double commentsSize;
  late String description;
  var createdAt;
  late String id;
  late String imageUrl;
  late String location;
  late double ratingsAverage;
  late int ratingsSize;
  late String status;
  late String title;
  late String uploadedBy;

  Location({
    required this.category,
    required this.commentsSize,
    required this.description,
    required this.createdAt,
    required this.id,
    required this.imageUrl,
    required this.location,
    required this.ratingsAverage,
    required this.ratingsSize,
    required this.status,
    required this.title,
    required this.uploadedBy,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> locationMap = Map<String, dynamic>();
    locationMap["category"] = category;
    locationMap["commentsSize"] = commentsSize;
    locationMap["createdAt"] = createdAt;
    locationMap["description"] = description;
    locationMap["id"] = id;
    locationMap["imageUrl"] = imageUrl;
    locationMap["location"] = location;
    locationMap["ratingsAverage"] = ratingsAverage;
    locationMap["ratingsSize"] = ratingsSize;
    locationMap["status"] = status;
    locationMap["title"] = title;
    locationMap["uploadedBy"] = uploadedBy;
    return locationMap;
  }

  Location.fromFirebase(Map<dynamic, dynamic> data) {
    category = data["category"];
    commentsSize = data["commentsSize"];
    createdAt = data["createdAt"];
    description = data["description"];
    id = data["id"];
    imageUrl = data["imageUrl"];
    location = data["location"];
    ratingsAverage = data["ratingsAverage"];
    ratingsSize = data["ratingsSize"];
    status = data["status"];
    title = data["title"];
    uploadedBy = data["uploadedBy"];
  }
}
