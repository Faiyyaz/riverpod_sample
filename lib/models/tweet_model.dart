class TweetModel {
  String text;
  String id;
  String userid;
  int createdAt;
  int updatedAt;
  String tweetType;

  TweetModel({
    required this.text,
    required this.id,
    required this.userid,
    required this.createdAt,
    required this.updatedAt,
    required this.tweetType,
  });

  factory TweetModel.fromJson(Map<String, dynamic> json) => TweetModel(
        text: json["text"],
        id: json["id"],
        userid: json["userid"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        tweetType: json["tweetType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "userid": userid,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "tweetType": tweetType,
      };
}
