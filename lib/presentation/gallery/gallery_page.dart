import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_viewer/domain/image/image.dart';
import 'package:photo_viewer/domain/token/login_token.dart';
import 'package:photo_viewer/presentation/gallery/components/gallery_item.dart';
import 'package:photo_viewer/presentation/gallery/gallery_view_model.dart';
import 'package:photo_viewer/presentation/login/login_page.dart';
import 'package:provider/provider.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  static const _pageSize = 20;
  final PagingController<int, ImageBasic> _pagingController = PagingController(firstPageKey: 0);
  late GalleryViewModel _galleryViewModel;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) async {
      List<ImageBasic> newImages = await _galleryViewModel.getImages(pageKey);
      final lastPage = newImages.length < _pageSize;
      if (lastPage) {
        _pagingController.appendLastPage(newImages);
      } else {
        final nextPageKey = ++pageKey;
        _pagingController.appendPage(
          newImages, nextPageKey.toInt()
        );
      }
    });
    if (Platform.isIOS) {
      refresh();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    _galleryViewModel = Provider.of<GalleryViewModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              showBottomSheet();
              FocusScope.of(context).unfocus();
            },
            icon: Image.asset(
              "assets/icons/plus.png",
              width: 24.w,
              height: 24.h,
            )
          ),
        ],
        title: IconButton(
          onPressed: () async {
            await LoginToken().deleteAllTokens();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage())
            );
          },
          icon: Image.asset(
              "assets/logos/logo.png",
              height: 25.h
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                    () => _pagingController.refresh(),
                ),
                child: PagedGridView<int, ImageBasic>(
                    pagingController: _pagingController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 172.w / 298.h,
                      crossAxisCount: 2,
                      mainAxisExtent: 298.h,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.w
                    ),
                    builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (BuildContext context, ImageBasic item, int index) {
                        return GalleryItem(image: item);
                      },
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Text(
                            "사진이 없어요",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          )
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
        ]
      ),
    );
  }
  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(10.r),
          topStart: Radius.circular(10.r),
        ),
      ),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            height: 150.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SheetContentScaffold(
                body: Column(
                  children: [
                    Consumer<GalleryViewModel>(
                      builder: (context, viewModel, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CupertinoListTile.notched(
                              onTap: () async {
                                var status = await Permission.camera.status;
                                if (status.isDenied) {
                                  await Permission.camera.request();
                                }
                                XFile? captureImage = await ImagePicker().pickImage(
                                  source: ImageSource.camera,
                                );
                                if (captureImage != null) {
                                  File result = File(captureImage.path);
                                  await viewModel.postImage(result);
                                }
                                Future.delayed(const Duration(milliseconds: 1000), () {
                                  refresh();
                                });
                              },
                              title: Text(
                                  "Camera",
                                  style: TextStyle(
                                    color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600
                                  )
                              ),
                              trailing: Image.asset(
                                "assets/icons/camera.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ),
                            CupertinoListTile.notched(
                              onTap: () async {
                                var status = await Permission.photos.status;
                                if (status.isDenied) {
                                  await Permission.photos.request();
                                }
                                XFile? captureImage = await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (captureImage != null) {
                                  File result = File(captureImage.path);
                                  viewModel.postImage(result);
                                }
                                Future.delayed(const Duration(milliseconds: 1000), () {
                                  refresh();
                                });
                              },
                              title: Text(
                                  "Gallery",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600
                                  )
                              ),
                              trailing: Image.asset(
                                "assets/icons/gallery.png",
                                width: 30.w,
                                height: 30.h,
                              ),
                            ),
                          ],
                        );
                      }
                    )
                  ],
                ),
              ),
            ),
          )
        );
      }
    );
  }

}