class VideoModel {
  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String creatorUid;
  final String creator;
  final int likes;
  final int comments;
  final int createdAt;

  VideoModel({
    required this.id,
    required this.description,
    required this.thumbnailUrl,
    required this.fileUrl,
    required this.creatorUid,
    required this.creator,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.title,
  });

  VideoModel.fromJson({
    required Map<String, dynamic> json,
    required String videoId,
  })  : description = json["description"],
        thumbnailUrl = json["thumbnailUrl"],
        fileUrl = json["fileUrl"],
        creatorUid = json["creatorUid"],
        creator = json["creator"],
        likes = json["likes"],
        comments = json["comments"],
        createdAt = json["createdAt"],
        id = videoId,
        title = json["title"];

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "thumbnailUrl": thumbnailUrl,
      "fileUrl": fileUrl,
      "creatorUid": creatorUid,
      "creator": creator,
      "likes": likes,
      "comments": comments,
      "createdAt": createdAt,
      "title": title,
      "id": id,
    };
  }
}
