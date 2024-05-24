class ImageBasic {
  String? imageUUID;
  String? imageUrl;
  String? uploaded;

  ImageBasic({
    this.imageUUID,
    this.imageUrl,
    this.uploaded
  });

  ImageBasic.fromJson(Map<String, dynamic> json) {
    imageUUID = json['image_uuid'] as String;
    imageUrl = json['image_url'] as String;
    // uploaded = new DateFormat("yyyy-MM-dd'T'hh:mm:ss").parse(json['uploaded'] as String)
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_uuid'] = imageUUID;
    data['image_url'] = imageUrl;
    data['uploaded'] = uploaded;
    return data;
  }
}