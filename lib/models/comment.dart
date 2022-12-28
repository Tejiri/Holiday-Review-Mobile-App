class Comment {
  var createdAt;
  var id;
  late String message;
  late String commentBy;

  Comment({
    required this.createdAt,
    required this.id,
    required this.message,
    required this.commentBy,
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> reviewMap = Map<String, dynamic>();
    reviewMap["createdAt"] = createdAt;
    reviewMap["id"] = id;
    reviewMap["message"] = message;
    reviewMap["commentBy"] = commentBy;
    return reviewMap;
  }

  Comment.fromFirebase(Map<dynamic, dynamic> data) {
    createdAt = data["createdAt"];
    id = data["id"];
    message = data["message"];
    commentBy = data["commentBy"];
  }
}
