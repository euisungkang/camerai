import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:photo_viewer/data/repository/image_repository.dart';
import 'package:photo_viewer/domain/image/image.dart';

class GalleryViewModel with ChangeNotifier {
  GalleryViewModel() {
    _imageRepository = ImageRepository();
  }

  Map<String, File?> fileMap = {};

  late final ImageRepository _imageRepository;

  Future<List<ImageBasic>> getImages(int page) async {
    return _imageRepository.getImages(page);
  }

  Future<void> postImage(File? file) async {
    List<ImageBasic> images = await _imageRepository.postImages(file);
    fileMap[images.first.imageUUID!] = file!;
  }

  Future<String> analyzeDescription(String imageUUID, String imageUrl) async {
    return await _imageRepository.analyzeDescription(imageUUID, imageUrl);
  }

  Future<List<String>> analyzeTags(String imageUUID) async {
    return await _imageRepository.analzyeTags(imageUUID, fileMap[imageUUID]);
  }
}