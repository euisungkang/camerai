import 'dart:io';
import 'package:photo_viewer/domain/image/image.dart';

import '../../domain/image/image_detail.dart';
import '../datasource/image_datasource.dart';

class ImageRepository {
  final ImageDataSource _imageDataSource = ImageDataSource();

  Future<List<ImageBasic>> getImages(int page) async {
    return _imageDataSource.getImages(page);
  }

  Future<ImageDetail> getImageDetail(String imageUUID) async {
    return _imageDataSource.getImageDetail(imageUUID);
  }

  Future<List<ImageBasic>> postImages(File? image) async {
    return _imageDataSource.postImages(image);
  }

  Future<String> analyzeDescription(String imageUUID, String imageUrl) async {
    return _imageDataSource.analyzeDescription(imageUUID, imageUrl);
  }

  Future<List<String>> analzyeTags(String imageUUID, File? image) async {
    return _imageDataSource.analyzeTags(imageUUID, image);
  }
}