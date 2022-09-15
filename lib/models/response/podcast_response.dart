// To parse this JSON data, do
//
//     final podcastResponse = podcastResponseFromJson(jsonString);

import 'dart:convert';

PodcastResponse podcastResponseFromJson(String str) =>
    PodcastResponse.fromJson(json.decode(str));

String podcastResponseToJson(PodcastResponse data) =>
    json.encode(data.toJson());

class PodcastResponse {
  PodcastResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.totalRows,
    this.podcasts,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  String? totalRows;
  List<Podcast>? podcasts;

  factory PodcastResponse.fromJson(Map<String, dynamic> json) =>
      PodcastResponse(
        status: json["Status"],
        statuscode: json["Statuscode"],
        statusDescription: json["StatusDescription"],
        totalRows: json["TotalRows"],
        podcasts: List<Podcast>.from(
            json["Response"].map((x) => Podcast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Statuscode": statuscode,
        "StatusDescription": statusDescription,
        "TotalRows": totalRows,
        "Response": List<dynamic>.from(podcasts!.map((x) => x.toJson())),
      };
}

class Podcast {
  Podcast(
      {this.folderFileId,
      this.podcastId,
      this.userId,
      this.rjname,
      this.dob,
      this.phone,
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
      this.likeCount,
      this.disLikeCount,
      this.heartCount,
      this.viewCount,
      this.commentCount,
      this.youLiked,
      this.youDisliked,
      this.youHearted,
      this.priorityRank,
      this.localFile,
      this.isSelected});

  String? folderFileId;
  String? podcastId;
  String? userId;
  String? rjname;
  String? dob;
  String? phone;
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
  String? likeCount;
  String? disLikeCount;
  String? heartCount;
  String? viewCount;
  String? commentCount;
  String? youLiked;
  String? youDisliked;
  String? youHearted;
  String? priorityRank;
  String? localFile;
  bool? isSelected;

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
        folderFileId: json["folder_file_id"],
        podcastId: json["podcast_id"],
        userId: json["rj_user_id"],
        rjname: json["rj_name"],
        dob: json["rj_dob"],
        phone: json["rj_phone"],
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
        likeCount: json["like_count"],
        disLikeCount: json["dislike_count"],
        heartCount: json["heart_count"],
        viewCount: json["view_count"],
        commentCount: json["comment_count"],
        youLiked: json["you_liked"],
        youDisliked: json["you_disliked"],
        youHearted: json["you_hearted"],
        priorityRank: json["priority_rank"],
        localFile: json["localFile"],
        isSelected: json["isSelected"],
      );

  Map<String, dynamic> toJson() => {
        "folder_file_id": folderFileId,
        "podcast_id": podcastId,
        "user_id": userId,
        "rj_name": rjname,
        "dob": dob,
        "phone": phone,
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
        "like_count": likeCount,
        "dislike_count": disLikeCount,
        "heart_count": heartCount,
        "view_count": viewCount,
        "comment_count": commentCount,
        "you_liked": youLiked,
        "you_disliked": youDisliked,
        "you_hearted": youHearted,
        "localFile": localFile,
        "isSelected": isSelected,
      };
}
