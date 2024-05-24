class ImageDetail {
  String? imageUUID;
  String? imageUrl;
  String? tagsUUID;
  List<String>? tags;
  String? description;
  String? uploaded;

  ImageDetail({
    this.imageUUID,
    this.imageUrl,
    this.tagsUUID,
    this.tags,
    this.description,
    this.uploaded,
  });

  ImageDetail.fromJson(Map<String, dynamic> json) {
    imageUUID = json['image_uuid'] as String;
    imageUrl = json['image_url'] as String;
    if (json['description'] != null) {
      description = json['description'] as String;
    }
    if (json['tags_uuid'] != null) {
      tagsUUID = json['tags_uuid'] as String;
    }
    if (json['tags'] != null) {
      tags = (json['tags'] as List).map((e) => e.toString()).toList();
    }
    uploaded = json['uploaded'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_uuid'] = imageUUID;
    data['image_url'] = imageUrl;
    data['tags_uuid'] = tagsUUID;
    data['tags'] = tags.toString();
    data['description'] = description;
    data['uploaded'] = uploaded;
    return data;
  }
}