import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_viewer/domain/image/image_detail.dart';
import 'package:photo_viewer/presentation/gallery/gallery_view_model.dart';
import 'package:provider/provider.dart';

class GalleryDetailPage extends StatefulWidget {
  late ImageDetail imageDetail;

  GalleryDetailPage({Key? key, required this.imageDetail}) : super(key: key);

  @override
  State<GalleryDetailPage> createState() => _GalleryDetailPageState();
}

class _GalleryDetailPageState extends State<GalleryDetailPage> {
  late ScrollController _scrollController;
  final GalleryViewModel galleryViewModel = GalleryViewModel();

  bool descLoading = true;
  bool tagsLoading = true;

  @override
  void initState() {
    super.initState();
    loadDesc();
    _scrollController = ScrollController();
  }

  loadDesc() async {
    if (widget.imageDetail.description == null || widget.imageDetail.description!.isEmpty) {
      widget.imageDetail.description = await galleryViewModel.analyzeDescription(widget.imageDetail.imageUUID!, widget.imageDetail.imageUrl!);
    }

    // if (widget.imageDetail.tags == null || widget.imageDetail.tags!.isEmpty) {
    //   widget.imageDetail.tags = await galleryViewModel.analyzeTags(widget.imageDetail.imageUUID!);
    // }
    setState(() {
      descLoading = false;
      // tagsLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
            "assets/logos/logo.png",
            height: 25.h
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageDetail.imageUrl!,
              fit: BoxFit.fitWidth,
            ),
            descLoading
                ? Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const CircularProgressIndicator()
                  )
                : Padding(
              padding: EdgeInsets.only(bottom: 50.h, left: 16.w, right: 16.w, top: 20.h),
              child: Text(
                widget.imageDetail.description!,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                )
              )
            ),
           // tagsLoading
           //      ? Padding(
           //      padding: EdgeInsets.symmetric(vertical: 12.h),
           //      child: const CircularProgressIndicator()
           //  )
           //      : Padding(
           //      padding: EdgeInsets.only(bottom: 50.h, left: 16.w, right: 16.w, top: 20.h),
           //      child: Text(
           //        widget.imageDetail.tags!.toString(),
           //          style: TextStyle(
           //            fontWeight: FontWeight.w500,
           //            fontSize: 16.sp,
           //          )
           //      )
           //  )
          ],
        )
      ),
    );
  }
}
