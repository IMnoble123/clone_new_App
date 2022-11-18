// To parse this JSON data, do
//
//     final unreadChatResponseData = unreadChatResponseDataFromJson(jsonString);

import 'dart:convert';

CommentResponse unreadChatResponseDataFromJson(String str) => CommentResponse.fromJson(json.decode(str));

String unreadChatResponseDataToJson(CommentResponse data) => json.encode(data.toJson());

class CommentResponse {
  CommentResponse({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.comments,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  List<Comment>? comments;

  factory CommentResponse.fromJson(Map<String, dynamic> json) => CommentResponse(
    status: json["Status"].toString(),
    statuscode: json["Statuscode"].toString(),
    statusDescription: json["StatusDescription"].toString(),
    comments: List<Comment>.from(json["Response"].map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "Response": List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

class Comment {
  Comment({
    this.commentId,
    this.commenterId,
    this.commentDescription,
    this.filepath,
    this.commenterName,
    this.commenterImage,
    this.commenterUsertype,
    this.commentDate,
    this.likecount,
    this.dislikecount,
    this.heartcount,
    this.commentYouLiked,
    this.commentYouDisliked,
    this.commentYouHearted,
    this.replyInputVisible,
    this.commentDateInago,
    this.replylist,
  });

  String? commentId;
  String? commenterId;
  String? commentDescription;
  String? filepath;
  String? commenterName;
  String? commenterImage;
  String? commenterUsertype;
  String? commentDate;
  String? likecount;
  String? dislikecount;
  String? heartcount;
  String? commentYouLiked;
  String? commentYouDisliked;
  String? commentYouHearted;
  bool? replyInputVisible;
  String? commentDateInago;
  List<Reply>? replylist;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentId: json["comment_id"].toString(),
    commenterId: json["commenter_id"].toString(),
    commentDescription: json["comment_description"].toString(),
    filepath: json["filepath"] == null ? null : json["filepath"].toString(),
    commenterName: json["commenter_name"].toString(),
    commenterImage: json["commenter_image"].toString(),
    commenterUsertype: json["commenter_usertype"].toString(),
    commentDate: json["comment_date"].toString(),
    likecount: json["likecount"].toString(),
    dislikecount: json["dislikecount"].toString(),
    heartcount: json["heartcount"].toString(),
    commentYouLiked: json["comment_you_liked"].toString(),
    commentYouDisliked: json["comment_you_disliked"].toString(),
    commentYouHearted: json["comment_you_hearted"].toString(),
    replyInputVisible: json["reply_input_visible"],
    commentDateInago: json["comment_date_inago"].toString(),
    replylist: List<Reply>.from(json["replylist"].map((x) => Reply.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "comment_id": commentId,
    "commenter_id": commenterId,
    "comment_description": commentDescription,
    "filepath": filepath == null ? null : filepath,
    "commenter_name": commenterName,
    "commenter_image": commenterImage,
    "commenter_usertype": commenterUsertype,
    "comment_date": commentDate,
    "likecount": likecount,
    "dislikecount": dislikecount,
    "heartcount": heartcount,
    "comment_you_liked": commentYouLiked,
    "comment_you_disliked": commentYouDisliked,
    "comment_you_hearted": commentYouHearted,
    "reply_input_visible": replyInputVisible,
    "comment_date_inago": commentDateInago,
    "replylist": List<dynamic>.from(replylist!.map((x) => x.toJson())),
  };
}

class Reply {
  Reply({
    this.replyId,
    this.replyerId,
    this.replyerName,
    this.replyerImage,
    this.replyerType,
    this.replyerDescription,
    this.replyDateInago,
    this.likecount,
    this.dislikecount,
    this.heartcount,
    this.replyYouLiked,
    this.replyYouDisliked,
    this.replyYouHearted,
    this.replyDate,
  });

  String? replyId;
  String? replyerId;
  String? replyerName;
  String? replyerImage;
  String? replyerType;
  String? replyerDescription;
  String? replyDateInago;
  String? likecount;
  String? dislikecount;
  String? heartcount;
  String? replyYouLiked;
  String? replyYouDisliked;
  String? replyYouHearted;
  String? replyDate;

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
    replyId: json["reply_id"].toString(),
    replyerId: json["replyer_id"].toString(),
    replyerName: json["replyer_name"].toString(),
    replyerImage: json["replyer_image"].toString(),
    replyerType: json["replyer_type"].toString(),
    replyerDescription: json["replyer_description"].toString(),
    replyDateInago: json["reply_date_inago"].toString(),
    likecount: json["likecount"].toString(),
    dislikecount: json["dislikecount"].toString(),
    heartcount: json["heartcount"].toString(),
    replyYouLiked: json["reply_you_liked"].toString(),
    replyYouDisliked: json["reply_you_disliked"].toString(),
    replyYouHearted: json["reply_you_hearted"].toString(),
    replyDate: json["reply_date"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "reply_id": replyId,
    "replyer_id": replyerId,
    "replyer_name": replyerName,
    "replyer_image": replyerImage,
    "replyer_type": replyerType,
    "replyer_description": replyerDescription,
    "reply_date_inago": replyDateInago,
    "likecount": likecount,
    "dislikecount": dislikecount,
    "heartcount": heartcount,
    "reply_you_liked": replyYouLiked,
    "reply_you_disliked": replyYouDisliked,
    "reply_you_hearted": replyYouHearted,
    "reply_date": replyDate,
  };
}
