class Location {
  late String category;
  var createdAt;
  late String declinationReason;
  late String description;
  late String id;
  late String imageUrl;
  late String location;
  var publishedAt;
  // late double ratingsAverage;
  late double ratingsSize;
  late double ratingsTotal;
  late String status;
  late String title;
  late String uploadedBy;

  Location({
    required this.category,
    required this.createdAt,
    required this.declinationReason,
    required this.description,
    required this.id,
    required this.imageUrl,
    required this.location,
    required this.publishedAt,
    // required this.ratingsAverage,
    required this.ratingsSize,
    required this.ratingsTotal,
    required this.status,
    required this.title,
    required this.uploadedBy,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> locationMap = Map<String, dynamic>();
    locationMap["category"] = category;
    locationMap["createdAt"] = createdAt;
    locationMap["declinationReason"] = declinationReason;
    locationMap["description"] = description;
    locationMap["id"] = id;
    locationMap["imageUrl"] = imageUrl;
    locationMap["location"] = location;
    locationMap["publishedAt"] = publishedAt;
    // locationMap["ratingsAverage"] = ratingsAverage;
    locationMap["ratingsSize"] = ratingsSize;
    locationMap["ratingsTotal"] = ratingsTotal;
    locationMap["status"] = status;
    locationMap["title"] = title;
    locationMap["uploadedBy"] = uploadedBy;
    return locationMap;
  }

  Location.fromFirebase(Map<dynamic, dynamic> data) {
    category = data["category"];
    createdAt = data["createdAt"];
    declinationReason = data["declinationReason"];
    description = data["description"];
    id = data["id"];
    imageUrl = data["imageUrl"];
    location = data["location"];
    publishedAt = data["publishedAt"];
    // ratingsAverage = data["ratingsAverage"];
    ratingsSize = data["ratingsSize"];
    ratingsTotal = data["ratingsTotal"];
    status = data["status"];
    title = data["title"];
    uploadedBy = data["uploadedBy"];
  }
}
