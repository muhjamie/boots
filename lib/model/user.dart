import 'package:google_maps_flutter/google_maps_flutter.dart';

class User {
  String key;
  String email;
  String userId;
  String displayName;
  String userName;
  String webSite;
  String profilePic;
  String contact;
  String bio;
  String location;
  double latitude;
  double longitude;
  String dob;
  String ppa;
  String stateOfDeployment;
  String localGovt;
  String createdAt;
  bool isVerified;
  int followers;
  int following;
  String fcmToken;
  List<String> followersList;
  List<String> followingList;

  User({
    this.email,
    this.userId,
    this.displayName,
    this.profilePic,
    this.key,
    this.contact,
    this.bio,
    this.dob,
    this.location,
    this.createdAt,
    this.userName,
    this.followers,
    this.following,
    this.webSite,
    this.isVerified,
    this.fcmToken,
    this.followersList,
    this.localGovt,
    this.ppa,
    this.stateOfDeployment,
    this.latitude,
    this.longitude,
    this.followingList
  });

  User.fromJson(Map<dynamic, dynamic> map) {
    if (map == null) {
      return;
    }
    if(followersList == null){
      followersList = [];
    }
    email = map['email'];
    userId = map['userId'];
    displayName = map['displayName'];
    profilePic = map['profilePic'];
    key = map['key'];
    dob = map['dob'];
    bio = map['bio'];
    location = map['location'];
    contact = map['contact'];
    createdAt = map['createdAt'];
    followers = map['followers'];
    following = map['following'];
    userName = map['userName'];
    webSite = map['webSite'];
    ppa = map['ppa'];
    stateOfDeployment = map['stateOfDeployment'];
    localGovt = map['localGovt'];
    fcmToken = map['fcmToken'];
    isVerified = map['isVerified'] ?? false;
    if(map['followerList'] != null){
      followersList = List<String>();
      map['followerList'].forEach((value){
         followersList.add(value);
     });
   }

   followers = followersList != null ? followersList.length : null;
   if(map['followingList'] != null){
      followingList = List<String>();
      map['followingList'].forEach((value){
         followingList.add(value);
     });
   }

   following = followingList != null ? followingList.length : null;
  }

  toJson() {
    return {
      'key': key,
      "userId": userId,
      "email": email,
      'displayName': displayName,
      'userId': userId,
      'profilePic': profilePic,
      'contact': contact,
      'dob': dob,
      'bio': bio,
      'ppa': ppa,
      'stateOfDeployment': stateOfDeployment,
      'localGovt': localGovt,
      'location': location,
      'createdAt': createdAt,
      'followers': followersList != null ? followersList.length : null,
      'following': followingList != null ? followingList.length : null,
      'userName': userName,
      'webSite': webSite,
      'isVerified': isVerified ?? false,
      'fcmToken':fcmToken,
      'followerList' : followersList,
      'followingList':followingList,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  toJsonUpdate() {
    return {
      'key': key,
      "userId": userId,
      "email": email,
      'displayName': displayName,
      'userId': userId,
      'profilePic': profilePic,
      'contact': contact,
      'dob': dob,
      'bio': bio,
      'ppa': ppa,
      'stateOfDeployment': stateOfDeployment,
      'localGovt': localGovt,
      'location': location,
      'createdAt': createdAt,
      'followers': followersList != null ? followersList.length : null,
      'following': followingList != null ? followingList.length : null,
      'userName': userName,
      'webSite': webSite,
      'isVerified': isVerified ?? false,
      'fcmToken':fcmToken,
      'followerList' : followersList,
      'followingList':followingList,
      'latitude': latitude,
      'longitude': longitude
    };
  }

  User copyWith({
    String email,
    String userId,
    String displayName,
    String profilePic,
    String key,
    String contact,
    bio,
    String dob,
    String location,
    String createdAt,
    String userName,
    int followers,
    int following,
    String webSite,
    String ppa,
    String stateOfDeployment,
    String localGovt,
    bool isVerified,
    String fcmToken,
    List<String> followingList,
    double latitude,
    double longitude

  }) {
    return User(
      email: email ?? this.email,
      bio: bio ?? this.bio,
      contact: contact ?? this.contact,
      createdAt: createdAt ?? this.createdAt,
      displayName: displayName ?? this.displayName,
      dob: dob ?? this.dob,
      followers: followersList != null ? followersList.length : null,
      following: following ?? this.following,
      isVerified: isVerified ?? this.isVerified,
      key: key ?? this.key,
      location: location ?? this.location,
      ppa: ppa ?? this.ppa,
      stateOfDeployment: stateOfDeployment ?? this.stateOfDeployment,
      localGovt: localGovt ?? this.localGovt,
      profilePic: profilePic ?? this.profilePic,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      webSite: webSite ?? this.webSite,
      fcmToken:fcmToken ?? this.fcmToken,
      followersList: followersList ?? this.followersList,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  String getFollower() {
    return '${this.followers ?? 0}';
  }

  String getFollowing() {
    return '${this.following ?? 0}';
  }

  LatLng getCoordinates() {
    return LatLng(this.latitude, this.longitude);
  }
}
