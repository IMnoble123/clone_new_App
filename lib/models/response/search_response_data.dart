// To parse this JSON data, do
//
//     final searchResponseData = searchResponseDataFromJson(jsonString);

import 'dart:convert';

import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';

SearchResponseData searchResponseDataFromJson(String str) => SearchResponseData.fromJson(json.decode(str));

String searchResponseDataToJson(SearchResponseData data) => json.encode(data.toJson());

class SearchResponseData {
  SearchResponseData({
    this.status,
    this.statuscode,
    this.statusDescription,
    this.response,
  });

  String? status;
  String? statuscode;
  String? statusDescription;
  Response? response;

  factory SearchResponseData.fromJson(Map<String, dynamic> json) => SearchResponseData(
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
    this.podcastList,
    this.rjList,
    this.showsList
  });

  List<Podcast>? podcastList;
  List<RjItem>? rjList;
  List<ShowItem>? showsList;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    podcastList: List<Podcast>.from(json["podcast_list"].map((x) => Podcast.fromJson(x))),
    rjList: List<RjItem>.from(json["rj_list"].map((x) => RjItem.fromJson(x))),
    showsList: List<ShowItem>.from(json["shows_list"].map((x) => ShowItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "podcast_list": List<dynamic>.from(podcastList!.map((x) => x.toJson())),
    "rj_list": List<dynamic>.from(rjList!.map((x) => x.toJson())),
    "shows_list": List<dynamic>.from(showsList!.map((x) => x.toJson())),
  };
}

