class DpPodcast {
  final String? podcastId;
  final String? userId;
  final String? rjname;
  final String? podcastName;
  final String? authorName;
  final String? imagepath;
  final String? audiopath;
  final String? likeCount;
  final String? broadcastDate;
  final String? localPath;

  const DpPodcast({this.podcastId, this.userId, this.rjname, this.podcastName,
      this.authorName, this.imagepath, this.audiopath,this.likeCount, this.broadcastDate, this.localPath});

  Map<String, dynamic> toMap() => {
    "podcast_id": podcastId,
    "user_id": userId,
    "rjname": rjname,
    "podcast_name": podcastName,
    "author_name": authorName,
    "imagepath": imagepath,
    "audiopath": audiopath,
    "like_count": likeCount,
    "broadcast_date": broadcastDate,
    "localPath": localPath,
  };


  factory DpPodcast.fromJson(Map<String, dynamic> json) => DpPodcast(
    podcastId: json["podcast_id"],
    userId: json["rj_user_id"],
    rjname: json["rjname"],
    podcastName: json["podcast_name"],
    authorName: json["author_name"],
    imagepath: json["imagepath"],
    audiopath: json["audiopath"],
    likeCount: json["like_count"],
    broadcastDate: json["broadcast_date"],
    localPath: json["localPath"],
  );



}
