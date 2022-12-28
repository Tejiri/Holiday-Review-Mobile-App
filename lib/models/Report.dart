class Report {
  late String commentId;
  var createdAt;
  late String locationId;
  late String message;
  late String reportReason;
  late String reportStatus;
  var reportedById;
  late String reportedId;
  late String reviewId;
  late String id;

  Report(
      {required this.commentId,
      required this.createdAt,
      required this.locationId,
      required this.message,
      required this.reportReason,
      required this.reportStatus,
      required this.reportedById,
      required this.reportedId,
      required this.reviewId,required this.id});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> reportMap = Map<String, dynamic>();
    reportMap["commentId"] = commentId;
    reportMap["createdAt"] = createdAt;
    reportMap["locationId"] = locationId;
    reportMap["message"] = message;
    reportMap["reportReason"] = reportReason;
    reportMap["reportStatus"] = reportStatus;
    reportMap["reportedById"] = reportedById;
    reportMap["reportedId"] = reportedId;
    reportMap["reviewId"] = reviewId;
    reportMap["id"] = id;
    return reportMap;
  }

  Report.fromFirebase(Map<dynamic, dynamic> data) {
    commentId = data["commentId"];
    createdAt = data["createdAt"];
    locationId = data["locationId"];
    message = data["message"];
    reportReason = data["reportReason"];
    reportStatus = data["reportStatus"];
    reportedById = data["reportedById"];
    reportedId = data["reportedId"];
    reviewId = data["reviewId"];
    id = data["id"];
  }
}
