// To parse this JSON data, do
//
//     final searchResponse = searchResponseFromJson(jsonString);

import 'dart:convert';

SearchResponse searchResponseFromJson(String str) => SearchResponse.fromJson(json.decode(str));

String searchResponseToJson(SearchResponse data) => json.encode(data.toJson());

class SearchResponse {
  SearchResponse({
    this.count,
    this.nextOffset,
    this.total,
    this.took,
    this.results,
  });

  int? count;
  int? nextOffset;
  int? total;
  double? took;
  List<Result>? results;

  factory SearchResponse.fromJson(Map<String, dynamic> json) => SearchResponse(
    count: json["count"],
    nextOffset: json["next_offset"],
    total: json["total"],
    took: json["took"].toDouble(),
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "next_offset": nextOffset,
    "total": total,
    "took": took,
    "results": List<dynamic>.from(results!.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.audio,
    this.audioLengthSec,
    this.rss,
    this.descriptionHighlighted,
    this.descriptionOriginal,
    this.titleHighlighted,
    this.titleOriginal,
    this.transcriptsHighlighted,
    this.image,
    this.thumbnail,
    this.itunesId,
    this.pubDateMs,
    this.id,
    this.listennotesUrl,
    this.explicitContent,
    this.link,
    this.guidFromRss,
    this.podcast,
  });

  String? audio;
  int? audioLengthSec;
  Rss? rss;
  String? descriptionHighlighted;
  String? descriptionOriginal;
  String? titleHighlighted;
  String? titleOriginal;
  List<String>? transcriptsHighlighted;
  String? image;
  String? thumbnail;
  int? itunesId;
  int? pubDateMs;
  String? id;
  String? listennotesUrl;
  bool? explicitContent;
  String? link;
  String? guidFromRss;
  Podcast? podcast;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    audio: json["audio"],
    audioLengthSec: json["audio_length_sec"],
    rss: rssValues.map![json["rss"]],
    descriptionHighlighted: json["description_highlighted"],
    descriptionOriginal: json["description_original"],
    titleHighlighted: json["title_highlighted"],
    titleOriginal: json["title_original"],
    transcriptsHighlighted: List<String>.from(json["transcripts_highlighted"].map((x) => x)),
    image: json["image"],
    thumbnail: json["thumbnail"],
    itunesId: json["itunes_id"],
    pubDateMs: json["pub_date_ms"],
    id: json["id"],
    listennotesUrl: json["listennotes_url"],
    explicitContent: json["explicit_content"],
    link: json["link"],
    guidFromRss: json["guid_from_rss"],
    podcast: Podcast.fromJson(json["podcast"]),
  );

  Map<String, dynamic> toJson() => {
    "audio": audio,
    "audio_length_sec": audioLengthSec,
    "rss": rssValues.reverse[rss],
    "description_highlighted": descriptionHighlighted,
    "description_original": descriptionOriginal,
    "title_highlighted": titleHighlighted,
    "title_original": titleOriginal,
    "transcripts_highlighted": List<dynamic>.from(transcriptsHighlighted!.map((x) => x)),
    "image": image,
    "thumbnail": thumbnail,
    "itunes_id": itunesId,
    "pub_date_ms": pubDateMs,
    "id": id,
    "listennotes_url": listennotesUrl,
    "explicit_content": explicitContent,
    "link": link,
    "guid_from_rss": guidFromRss,
    "podcast": podcast!.toJson(),
  };
}

class Podcast {
  Podcast({
    this.listennotesUrl,
    this.id,
    this.titleHighlighted,
    this.titleOriginal,
    this.publisherHighlighted,
    this.publisherOriginal,
    this.image,
    this.thumbnail,
    this.genreIds,
    this.listenScore,
    this.listenScoreGlobalRank,
  });

  String? listennotesUrl;
  String? id;
  String? titleHighlighted;
  String? titleOriginal;
  String? publisherHighlighted;
  String? publisherOriginal;
  String? image;
  String? thumbnail;
  List<int>? genreIds;
  Rss? listenScore;
  Rss? listenScoreGlobalRank;

  factory Podcast.fromJson(Map<String, dynamic> json) => Podcast(
    listennotesUrl: json["listennotes_url"],
    id: json["id"],
    titleHighlighted: json["title_highlighted"],
    titleOriginal: json["title_original"],
    publisherHighlighted: json["publisher_highlighted"],
    publisherOriginal: json["publisher_original"],
    image: json["image"],
    thumbnail: json["thumbnail"],
    genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
    listenScore: rssValues.map![json["listen_score"]],
    listenScoreGlobalRank: rssValues.map![json["listen_score_global_rank"]],
  );

  Map<String, dynamic> toJson() => {
    "listennotes_url": listennotesUrl,
    "id": id,
    "title_highlighted": titleHighlighted,
    "title_original": titleOriginal,
    "publisher_highlighted": publisherHighlighted,
    "publisher_original": publisherOriginal,
    "image": image,
    "thumbnail": thumbnail,
    "genre_ids": List<dynamic>.from(genreIds!.map((x) => x)),
    "listen_score": rssValues.reverse[listenScore],
    "listen_score_global_rank": rssValues.reverse[listenScoreGlobalRank],
  };
}

enum Rss { PLEASE_UPGRADE_TO_PRO_OR_ENTERPRISE_PLAN_TO_SEE_THIS_FIELD }

final rssValues = EnumValues({
  "Please upgrade to PRO or ENTERPRISE plan to see this field": Rss.PLEASE_UPGRADE_TO_PRO_OR_ENTERPRISE_PLAN_TO_SEE_THIS_FIELD
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
