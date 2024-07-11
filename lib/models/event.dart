import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/models/post.dart';

// Event can be exhibition, art fair, studio visit, talks etc.
class EventModel extends PostModel {
  String? eventName;
  String? eventLocation;
  String? eventWebsite;
  Timestamp? startTime;
  Timestamp? endTime;
  String? organizer;
  String? eventImageUrl;
  int? maxParticipants;
  List<String>? participants;
  List<String>? followerIds;

  EventModel({
    this.eventName,
    this.eventLocation,
    this.eventWebsite,
    this.startTime,
    this.endTime,
    this.organizer,
    this.eventImageUrl,
    this.maxParticipants,
    this.participants,
    this.followerIds,
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

  // Convert EventModel to JSON
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['eventName'] = this.eventName;
    data['eventLocation'] = this.eventLocation;
    data['eventWebsite'] = this.eventWebsite;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['organizer'] = this.organizer;
    data['eventImageUrl'] = this.eventImageUrl;
    data['maxParticipants'] = this.maxParticipants;
    data['participants'] = this.participants;
    data['followerIds'] = this.followerIds;
    return data;
  }

  // Create an EventModel from JSON data
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
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
      eventName: json['eventName'],
      eventLocation: json['eventLocation'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      organizer: json['organizer'],
      eventImageUrl: json['eventImageUrl'],
      maxParticipants: json['maxParticipants'],
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : null,
      followerIds: json['followerIds']!= null
          ? List<String>.from(json['followerIds'])
          : null,
    );
  }
}