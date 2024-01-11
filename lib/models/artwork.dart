import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/post.dart';
import 'package:social_media_app/models/enum/size_unit_type.dart';
import 'package:social_media_app/models/enum/rarity_type.dart';

class Dimensions {
  final double length;
  final double width;
  final double height;
  final SizeUnitType unitType;

  Dimensions({
    required this.length,
    required this.width,
    required this.height,
    required this.unitType,
  });

  @override
  String toString() {
    String unitString = unitType == SizeUnitType.CM ? 'cm' : 'inches';
    return 'Dimensions [ length: $length$unitString, width: $width$unitString, height: $height$unitString ]';
  }
}

class ArtworkModel extends PostModel {
  // Users who create the artwork itself, not the post of artwork on the app.
  List<String>? creatorList;
  List<String>? followerList;

  List<String>? imageUrlList;
  String? yearCreated;
  Timestamp? uploadedTimestamp;

  String? title;
  Dimensions? artworkDimensions;
  RarityType? rarityType;

  // Posts that are linked to this artwork.
  List<String>? postIdList;

  // TODO(feature): if the current artwork participated any exhibition/events.

  ArtworkModel({
    this.creatorList,
    this.followerList,
    this.imageUrlList,
    this.yearCreated,
    this.uploadedTimestamp,
    this.title,
    this.artworkDimensions,
    this.rarityType,
    this.postIdList,
    // Other properties inherited from PostModel
    String? id,
    String? postId,
    String? ownerId,
    String? ownerDp,
    String? location,
    String? description,
    String? mediaUrl,
    String? username,
    List<String>? artworkIdList,
    Timestamp? timestamp,
    List<String>? mediaUrlList,
  }) : super(
          id: id,
          postId: postId,
          ownerId: ownerId,
          ownerDp: ownerDp,
          location: location,
          description: description,
          mediaUrl: mediaUrl,
          username: username,
          artworkIdList: artworkIdList,
          timestamp: timestamp,
          mediaUrlList: mediaUrlList,
        );

  // Convert ArtworkModel to JSON
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['creatorList'] = this.creatorList;
    data['followerList'] = this.followerList;
    data['imageUrlList'] = this.imageUrlList;
    data['yearCreated'] = this.yearCreated;
    data['uploadedTimestamp'] = this.uploadedTimestamp;
    data['title'] = this.title;
    data['description'] = this.description;
    data['rarityType'] = this.rarityType.toString();

    if (this.artworkDimensions != null) {
      data['artworkDimensions'] = {
        'length': this.artworkDimensions!.length,
        'width': this.artworkDimensions!.width,
        'height': this.artworkDimensions!.height,
        'unitType': this.artworkDimensions!.unitType.toString(),
      };
    }
    data['postIdList'] = this.postIdList;
    return data;
  }

  // Create an ArtworkModel from JSON data
  factory ArtworkModel.fromJson(Map<String, dynamic> json) {
    return ArtworkModel(
      id: json['id'],
      postId: json['postId'],
      ownerId: json['ownerId'],
      ownerDp: json['ownerDp'],
      location: json['location'],
      description: json['description'],
      mediaUrl: json['mediaUrl'],
      username: json['username'],
      artworkIdList: json['artworkIdList'],
      timestamp: json['timestamp'],
      mediaUrlList: json['mediaUrlList'],
      creatorList: json['creatorList'],
      followerList: json['followerList'],
      imageUrlList: json['imageUrlList'],
      yearCreated: json['yearCreated'],
      uploadedTimestamp: json['uploadedTimestamp'],
      title: json['title'],
      artworkDimensions: json['artworkDimensions'] != null
          ? Dimensions(
              length: json['artworkDimensions']['length'],
              width: json['artworkDimensions']['width'],
              height: json['artworkDimensions']['height'],
              unitType: json['artworkDimensions']['unitType'] == 'CM'
                  ? SizeUnitType.CM
                  : SizeUnitType.INCH,
            )
          : null,
      postIdList: json['postIdList'],
    );
  }
}
