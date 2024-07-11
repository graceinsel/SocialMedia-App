import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? id;
  String? postId;
  String? ownerId;
  String? ownerDp;
  String? username;
  String? location;
  String? description;
  // TODO(feature): If the post is related to an artwork, set it here.
  // Case 1: when user upload an artwork to their portfolio, automatically
  //         create a feed linked to the artwork.
  // Case 2: ..
  List<String>? artworkIdList;
  Timestamp? timestamp;

  // TODO(feature): decide if media is required or not.
  List<String>? mediaUrlList;
  // change this mediaUrl to a list of media, to support multi image feed.
  String? mediaUrl;

  // TODO(feature): repost and share

  // TODO(feature): feature as on linkedin, when user comment or liked a post, an
  // artwork or a event, make it a news feed.
  

  PostModel({
    this.id,
    this.postId,
    this.ownerId,
    this.ownerDp,
    this.location,
    this.description,
    this.mediaUrl,
    this.username,
    this.artworkIdList,
    this.timestamp,
    this.mediaUrlList,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['postId'];
    ownerId = json['ownerId'];
    ownerDp = json['ownerDp'];
    location = json['location'];
    username= json['username'];
    description = json['description'];
    mediaUrl = json['mediaUrl'];
    artworkIdList = json['artworkIdList'];
    timestamp = json['timestamp'];
    mediaUrlList = json['mediaUrlList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['postId'] = this.postId;
    data['ownerId'] = this.ownerId;
    data['ownerDp'] = this.ownerDp;
    data['location'] = this.location;
    data['description'] = this.description;
    data['mediaUrl'] = this.mediaUrl;
    data['artworkIdList'] = this.artworkIdList;
    data['timestamp'] = this.timestamp;
    data['username'] = this.username;
    data['mediaUrlList'] = this.mediaUrlList;
    return data;
  }
}
