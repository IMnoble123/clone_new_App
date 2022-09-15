// To parse this JSON data, do
//
//     final subscibedResponseData = subscibedResponseDataFromJson(jsonString);

import 'dart:convert';

import 'package:podcast_app/models/response/podcast_response.dart';

SubscibedResponseData subscibedResponseDataFromJson(String str) => SubscibedResponseData.fromJson(json.decode(str));

String subscibedResponseDataToJson(SubscibedResponseData data) => json.encode(data.toJson());

class SubscibedResponseData {
  SubscibedResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  Response? response;

  factory SubscibedResponseData.fromJson(Map<String, dynamic> json) => SubscibedResponseData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    response: Response.fromJson(json["Response"]),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": response!.toJson(),
  };
}

class Response {
  Response({
    this.rjList,
    this.podcastList,
  });

  List<RjList>? rjList;
  List<Podcast>? podcastList;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    rjList: List<RjList>.from(json["rj_list"].map((x) => RjList.fromJson(x))),
    podcastList: List<Podcast>.from(json["podcast_list"].map((x) => Podcast.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "rj_list": List<dynamic>.from(rjList!.map((x) => x.toJson())),
    "podcast_list": List<dynamic>.from(podcastList!.map((x) => x.toJson())),
  };
}

/*class SubPodcast {
  SubPodcast({
    this.podcastId,
    this.rjUserId,
    this.rjName,
    this.rjDob,
    this.rjPhone,
    this.podcastName,
    this.authorName,
    this.language,
    this.category,
    this.description,
    this.imagepath,
    this.audiopath,
    this.broadcastDate,
    this.uploadDate,
    this.ageRestriction,
    this.viewCount,
    this.commentCount,
  });

  String? podcastId;
  String? rjUserId;
  String? rjName;
  String? rjDob;
  String? rjPhone;
  String? podcastName;
  String? authorName;
  String? language;
  String? category;
  String? description;
  String? imagepath;
  String? audiopath;
  String? broadcastDate;
  String? uploadDate;
  String? ageRestriction;
  String? viewCount;
  String? commentCount;

  factory SubPodcast.fromJson(Map<String, dynamic> json) => SubPodcast(
    podcastId: json["podcast_id"],
    rjUserId: json["rj_user_id"],
    rjName: json["rj_name"],
    rjDob: json["rj_dob"],
    rjPhone: json["rj_phone"],
    podcastName: json["podcast_name"],
    authorName: json["author_name"],
    language: json["language"],
    category: json["category"],
    description: json["description"],
    imagepath: json["imagepath"],
    audiopath: json["audiopath"],
    broadcastDate: json["broadcast_date"],
    uploadDate: json["upload_date"],
    ageRestriction: json["age_restriction"],
    viewCount: json["view_count"],
    commentCount: json["comment_count"],
  );

  Map<String, dynamic> toJson() => {
    "podcast_id": podcastId,
    "rj_user_id": rjUserId,
    "rj_name": rjName,
    "rj_dob": rjDob,
    "rj_phone": rjPhone,
    "podcast_name": podcastName,
    "author_name": authorName,
    "language": language,
    "category": category,
    "description": description,
    "imagepath": imagepath,
    "audiopath": audiopath,
    "broadcast_date": broadcastDate,
    "upload_date": uploadDate,
    "age_restriction": ageRestriction,
    "view_count": viewCount,
    "comment_count": commentCount,
  };
}*/

/*enum Language { TELUGU, HINDI, TAMIL, KANNADA }

final languageValues = EnumValues({
  "Hindi": Language.HINDI,
  "Kannada": Language.KANNADA,
  "Tamil": Language.TAMIL,
  "Telugu": Language.TELUGU
});*/

class RjList {
  RjList({
    this.id,
    this.rjUserId,
    this.rjName,
    this.rjDob,
    this.rjPhone,
    this.profileImage,
  });

  String? id;
  String? rjUserId;
  String? rjName;
  String? rjDob;
  String? rjPhone;
  String? profileImage;

  factory RjList.fromJson(Map<String, dynamic> json) => RjList(
    id: json["id"],
    rjUserId: json["rj_user_id"],
    rjName: json["rj_name"],
    rjDob: json["rj_dob"],
    rjPhone: json["rj_phone"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rj_user_id": rjUserId,
    "rj_name": rjName,
    "rj_dob": rjDob,
    "rj_phone": rjPhone,
    "profile_image": profileImage,
  };
}

/*class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}*/
