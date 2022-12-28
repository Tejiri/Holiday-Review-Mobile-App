class Review {
  var createdAt;
  var id;
  late String message;
  late double rating;
  late String reviewBy;

  Review({
    required this.createdAt,
    required this.id,
    required this.message,
    required this.rating,
    required this.reviewBy,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> reviewMap = Map<String, dynamic>();
    reviewMap["createdAt"] = createdAt;
    reviewMap["id"] = id;
    reviewMap["message"] = message;
    reviewMap["rating"] = rating;
    reviewMap["reviewBy"] = reviewBy;
    return reviewMap;
  }

  Review.fromFirebase(Map<dynamic, dynamic> data) {
    createdAt = data["createdAt"];
    if (data["id"] != null) {
      id = data["id"];
    }
    
    message = data["message"];
    rating = data["rating"].toDouble();
    reviewBy = data["reviewBy"];
  }
}
