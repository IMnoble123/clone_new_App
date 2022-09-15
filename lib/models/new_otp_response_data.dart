// To parse this JSON data, do
//
//     final newOtpResponseData = newOtpResponseDataFromJson(jsonString);

import 'dart:convert';

import 'package:podcast_app/models/response/user_response_data.dart';

NewOtpResponseData newOtpResponseDataFromJson(String str) => NewOtpResponseData.fromJson(json.decode(str));

String newOtpResponseDataToJson(NewOtpResponseData data) => json.encode(data.toJson());

class NewOtpResponseData {
  NewOtpResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.totalRows,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  String? totalRows;
  NewOtpResponse? response;

  factory NewOtpResponseData.fromJson(Map<String, dynamic> json) => NewOtpResponseData(
    status: json["Status"],
    statuscode: json["Statuscode"],
    statusDescription: json["StatusDescription"],
    totalRows: json["TotalRows"],
    response: NewOtpResponse.fromJson(json["Response"]),
  );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Statuscode": statuscode,
    "StatusDescription": statusDescription,
    "TotalRows": totalRows,
    "Response": response!.toJson(),
  };
}

class NewOtpResponse {
  NewOtpResponse({
    this.message,
    this.usertype,
    this.token,
    this.userdata,
  });

  String? message;
  String? usertype;
  String? token;
  dynamic userdata;

  factory NewOtpResponse.fromJson(Map<String, dynamic> json) => NewOtpResponse(
    message: json["message"],
    usertype: json["usertype"],
    token: json["token"],
    userdata: json["userdata"],
    // userdata: UserResponseData.fromJson(json["userdata"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "usertype": usertype,
    "token": token,
    "userdata": userdata,
    // "userdata": userdata!.toJson(),
  };
}

/*class Userdata {
  Userdata({
    this.id,
    this.mobile,
    this.email,
    this.name,
    this.dob,
    this.gender,
    this.profileImage,
    this.source,
    this.prefLanguage,
    this.createdDate,
    this.status,
    this.token,
  });

  String? id;
  String? mobile;
  String? email;
  String? name;
  String? dob;
  String? gender;
  String? profileImage;
  String? source;
  String? prefLanguage;
  String? createdDate;
  String? status;
  String? token;

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    id: json["id"],
    mobile: json["mobile"],
    email: json["email"],
    name: json["name"],
    dob: json["dob"],
    gender: json["gender"],
    profileImage: json["profile_image"],
    source: json["source"],
    prefLanguage: json["pref_language"],
    createdDate: json["created_date"],
    status: json["status"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile": mobile,
    "email": email,
    "name": name,
    "dob": dob,
    "gender": gender,
    "profile_image": profileImage,
    "source": source,
    "pref_language": prefLanguage,
    "created_date": createdDate,
    "status": status,
    "token": token,
  };
}*/
