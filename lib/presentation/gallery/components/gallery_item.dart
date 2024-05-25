import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_viewer/data/repository/image_repository.dart';
import 'package:photo_viewer/domain/image/image.dart';
import 'package:photo_viewer/domain/image/image_detail.dart';
import 'package:photo_viewer/presentation/gallery/gallery_detail_page.dart';

class GalleryItem extends StatefulWidget {
  GalleryItem({Key? key, required this.image}) : super(key: key);

  final ImageBasic image;

  @override
  State<GalleryItem> createState() => _GalleryItemPageState();
}

class _GalleryItemPageState extends State<GalleryItem> {

  late final ImageRepository _imageRepository = ImageRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        ImageDetail item = await _imageRepository.getImageDetail(widget.image.imageUUID!);
        print(item.imageUUID);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GalleryDetailPage(imageDetail: item)
          ),
        );
      },
      child: SizedBox(
        width: 172.w,
        height: 298.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Container(
                  child: CachedNetworkImage(
                      imageUrl: widget.image.imageUrl!,
                      fit: BoxFit.cover,
                      width: 172.w,
                      height: 298.h
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}