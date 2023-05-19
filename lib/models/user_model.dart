class UserModel {
  String email;
  String name;
  List<String>? followers;
  List<String>? following;
  String? profilePicture;
  String? bannerPicture;
  String userId;
  String? bio;
  bool isTwitterBlue;

  UserModel({
    required this.email,
    required this.name,
    this.followers,
    this.following,
    this.profilePicture,
    this.bannerPicture,
    this.bio,
    required this.userId,
    this.isTwitterBlue = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        email: json["email"],
        name: json["name"],
        bio: json["bio"],
        followers: json["followers"] != null
            ? List<String>.from(json["followers"].map((x) => x))
            : [],
        following: json["following"] != null
            ? List<String>.from(json["following"].map((x) => x))
            : [],
        profilePicture: json["profilePicture"],
        bannerPicture: json["bannerPicture"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "name": name,
        "bio": bio,
        "followers": followers != null
            ? List<dynamic>.from(followers!.map((x) => x))
            : followers,
        "following": following != null
            ? List<dynamic>.from(following!.map((x) => x))
            : following,
        "profilePicture": profilePicture,
        "bannerPicture": bannerPicture,
        "userId": userId,
      };
}
