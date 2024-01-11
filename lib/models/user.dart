import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? username;
  String? email;
  String? photoUrl;
  String? country;
  String? bio;
  String? headline;
  String? id;
  Timestamp? signedUpAt;
  Timestamp? lastSeen;
  bool? isOnline;
  List<String>? artworkCreatedList;
  List<String>? artworkFollowedList;
  List<String>? artworkCollectedList;

  UserModel(
      {this.username,
      this.email,
      this.id,
      this.photoUrl,
      this.signedUpAt,
      this.isOnline,
      this.lastSeen,
      this.bio,
      this.headline,
      this.country});

  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    country = json['country'];
    photoUrl = json['photoUrl'];
    signedUpAt = json['signedUpAt'];
    isOnline = json['isOnline'];
    lastSeen = json['lastSeen'];
    bio = json['bio'];
    headline = json['headline'];
    id = json['id'];

    artworkCollectedList = json['artworkCollectedList'];
    artworkCreatedList = json['artworkCreatedList'];
    artworkFollowedList = json['artworkFollowedList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['country'] = this.country;
    data['email'] = this.email;
    data['photoUrl'] = this.photoUrl;
    data['bio'] = this.bio;
    data['headline'] = this.headline;
    data['signedUpAt'] = this.signedUpAt;
    data['isOnline'] = this.isOnline;
    data['lastSeen'] = this.lastSeen;
    data['id'] = this.id;
    data['artworkCreatedList'] = this.artworkCreatedList;
    data['artworkCollectedList'] = this.artworkCollectedList;
    data['artworkFollwedList'] = this.artworkFollowedList;
    return data;
  }
}
