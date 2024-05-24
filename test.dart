import 'dart:convert';

import 'package:SoSangGongGan/constants/firebase_analysis_constants.dart';
import 'package:SoSangGongGan/data/repository/normal_product_repository.dart';
import 'package:SoSangGongGan/domain/model/normal_product/normal_product.dart';
import 'package:SoSangGongGan/domain/model/user/user_information.dart';
import 'package:SoSangGongGan/logger.dart';
import 'package:SoSangGongGan/presentation/custom_widget/extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../../data/filter.dart';
import '../../../data/repository/user_repository.dart';
import '../../../domain/model/normal_product/normal_product_detail.dart';
import '../../../domain/model/user/login_token.dart';
import '../../product_detail/normal_detail/normal_product_detail_page.dart';

class NormalProductItemPage extends StatefulWidget {
  NormalProductItemPage({Key? key, required this.product})
      : super(key: key);

  final NormalProduct product;

  @override
  State<NormalProductItemPage> createState() => _NormalProductItemPageState();
}

class _NormalProductItemPageState extends State<NormalProductItemPage> {
  bool clickable = true;
  bool isLiked = true;
  bool isMine = false;
  String? baseUrl = dotenv.env['PRODUCTION_BASE_URL'];

  late final NormalProductRepository _normalProductRepository = NormalProductRepository();

  _fetchProductDetail(String itemKey) async {
    return _normalProductRepository.getProductDetailByUUID(itemKey);
  }

  void _updateLike(bool liked) async {
    if (liked) {
      _normalProductRepository.likeProduct(widget.product.productUUID!);
    } else {
      _normalProductRepository.unlikeProduct(widget.product.productUUID!);
    }
  }

  @override
  void initState() {
    isLiked = widget.product.isLiked!;
    print(widget.product.countChattingRoom);
    //wish page에서는 widget.product.userID null임
    if (UserInformation().userUUID == widget.product.userID) {
      isMine = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickable == false
          ? null
          : () async {
        setState(() {
          clickable = false;
        });
        NormalProductDetail item =
        await _fetchProductDetail(widget.product.productUUID!);
        setState(() {
          clickable = true;
        });
        await FirebaseAnalytics.instance.logEvent(name: FirebaseAnalysisConstants.storeDetail,parameters: {FirebaseAnalysisConstants.productUUID: widget.product.productUUID!});

        bool result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NormalProductDetailPage(productDetail: item)));
        setState(() {
          isLiked = result;
        });
      },
      child: SizedBox(
        width: 172.w,
        height: 298.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product.isSold != null && widget.product.isSold!
                ? Stack(alignment: Alignment.bottomRight, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: CachedNetworkImage(
                  imageUrl: widget.product.thumbnail_url!,
                  fit: BoxFit.cover,
                  width: 172.w,
                  height: 172.h,
                ),
              ),
              Container(
                width: 172.w,
                height: 172.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: const Color(0x70000000)),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w, bottom: 8.h),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.r)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    child: Text(
                      "판매 완료",
                      style: TextStyle(
                          color: const Color(0xFF1B1B1B),
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          height: 1.40.h),
                    ),
                  ),
                ),
              )
            ])
                : Stack(alignment: Alignment.bottomRight, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Container(
                    color: const Color(0xFFE0E0E0),
                    child: CachedNetworkImage(
                      imageUrl: widget.product.thumbnail_url!,
                      fit: BoxFit.cover,
                      width: 172.w,
                      height: 172.h,
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.only(right: 0.w, bottom: 0.h),
                child: isLiked
                    ? IconButton(
                  onPressed: isMine
                      ? null
                      : () async{
                    await FirebaseAnalytics.instance.logEvent(name: FirebaseAnalysisConstants.storeLike,parameters: {FirebaseAnalysisConstants.productUUID: widget.product.productUUID!});

                    isLiked = false;
                    widget.product.countLiked = widget.product.countLiked! - 1;
                    _updateLike(isLiked);
                    setState(() {});
                  },
                  icon: Image.asset(
                      'assets/icons/ic_heart_colored.png'),
                  iconSize: 24.w,
                  constraints: BoxConstraints(maxWidth: 45.w),
                )
                    : IconButton(
                  onPressed: isMine
                      ? null
                      : () {
                    isLiked = true;
                    widget.product.countLiked = widget.product.countLiked! + 1;
                    _updateLike(isLiked);
                    setState(() {});
                  },
                  icon: Image.asset(
                      'assets/icons/ic_outlined_heart.png'),
                  iconSize: 24.w,
                  constraints: BoxConstraints(maxWidth: 45.w),
                ),
              )
            ]),
            Padding(
              padding: EdgeInsets.only(top: 7.h, bottom: 5.h),
              child: Text(
                widget.product.productName!,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF464646)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.h),
              child: Text(
                "${widget.product.price.toString().numberFormat()}원",
                style: TextStyle(
                    color: const Color(0xFF1B1B1B),
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: Text(
                Filter.largeRegionName.contains(widget.product.location!)
                    ? widget.product.location!
                    : '서울시 ${widget.product.location!}',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFA0A0A0)),
              ),
            ),
            Expanded(
                child:
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/ic_comment.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, right: 8.w),
                      child: Text(
                        widget.product.countChattingRoom.toString(),
                        style: TextStyle(
                            color: const Color(0xFF7F7F7F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/ic_heart.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, right: 8.w),
                      child: Text(
                        widget.product.countLiked!.toString(),
                        style: TextStyle(
                            color: const Color(0xFF7F7F7F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Image.asset(
                      'assets/icons/ic_eye.png',
                      width: 16.w,
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.w),
                      child: Text(
                        widget.product.views!.toString(),
                        style: TextStyle(
                            color: const Color(0xFF7F7F7F),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
