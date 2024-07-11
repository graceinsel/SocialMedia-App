import 'package:cloud_firestore/cloud_firestore.dart';

// TODO(feature): when user add a hashtag, create/update HashTag.
class HashTag {
  String? id;
  String? tagLabel;
  // User who created the hashtag.
  String? ownerId;
  // Post which are tagged with this hashTag.
  List<String>? postIdList;
  Timestamp? timestamp;
  // Users who followed the hashtag.
  List<String>? followerList;

  HashTag({
    this.id,
    this.tagLabel,
    this.ownerId,
    this.postIdList,
    this.timestamp,
    this.followerList,
  });

  HashTag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    tagLabel = json['tagLabel'];
    ownerId = json['ownerId'];
    postIdList = json['postIdList'];
    timestamp = json['timestamp'];
    followerList = json['followerList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ownerId'] = this.ownerId;
    data['tagLabel'] = this.tagLabel;
    data['ownerId'] = this.ownerId;
    data['postIdList'] = this.postIdList;
    data['timestamp'] = this.timestamp;
    data['followerList'] = this.followerList;
    return data;
  }
}
