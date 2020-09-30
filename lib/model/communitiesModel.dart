class CommunitiesModel {
  final String key;
  final String communityId;
  final String adminId;
  final String communityName;
  final String createdAt;
  final String timeStamp;

  CommunitiesModel({
    this.key,
    this.adminId,
    this.communityId,
    this.communityName,
    this.createdAt,
    this.timeStamp
  });

  factory CommunitiesModel.fromJson(Map<dynamic, dynamic> json) => CommunitiesModel(
      key: json["key"],
      adminId: json["adminId"],
      communityId: json['communityId'],
      communityName: json["communityName"],
      createdAt: json["createdAt"],
      timeStamp:json['timeStamp'],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "adminId": adminId,
    "communityId": communityId,
    "communityName": communityName,
    "created_at": createdAt,
    "timeStamp":timeStamp
  };
}
