import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaCustom {
  //show thumbnail video
  // static Widget videoThumbnail(
  //     {required String videoUrl, dynamic controller, bool? isProfile = false}) {
  //   int index = -1;
  //   if (listThumbnailCacheLocal.isNotEmpty) {
  //     index = listThumbnailCacheLocal.indexWhere((e) => e.videoUrl == videoUrl);
  //     // Sử dụng hình ảnh từ cache nếu có.
  //     if (index != -1) {
  //       return isProfile == true
  //           ? _buildThumbnailImageProfile(listThumbnailCacheLocal[index].file)
  //           : _buildThumbnailImageChatDetail(
  //           listThumbnailCacheLocal[index].file);
  //     }
  //   }
  //
  //   return
  //     // Container(child: Text('video'));
  //     FutureBuilder<String?>(
  //       future: _generateThumbnail(videoUrl, controller),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done &&
  //             snapshot.hasData) {
  //           var thumb = ThumbnailCacheVideo(
  //               videoUrl, snapshot.data ?? '', controller.timeNow);
  //           if (listThumbnailCacheLocal.isNotEmpty) {
  //             var index = listThumbnailCacheLocal
  //                 .indexWhere((e) => e.videoUrl == videoUrl);
  //             if (index == -1) {
  //               //truyền time của tin nhắn hiện tại chưa biết nên truyền time now, biết sẽ sửa để check
  //               controller.addThumbnailCacheVideoToLocal(thumb);
  //             }
  //           } else {
  //             controller.addThumbnailCacheVideoToLocal(thumb);
  //           }
  //           // Lưu hình ảnh vào cache và hiển thị nó.
  //           return
  //             // Container(child: Text('video'));
  //             isProfile == true
  //                 ? _buildThumbnailImageProfile(snapshot.data!)
  //                 : _buildThumbnailImageChatDetail(snapshot.data!);
  //         } else {
  //           return Center(
  //             child: Container(
  //               margin: EdgeInsets.symmetric(vertical: 20.h),
  //               height: 40.h,
  //               width: 40.w,
  //               child: const CircularProgressIndicator(strokeWidth: 3),
  //             ),
  //           );
  //         }
  //       },
  //     );
  // }

  // static Future<String?> _generateThumbnail(
  //     String videoUrl, dynamic controller) {
  //   var file = VideoThumbnail.thumbnailFile(
  //       video: videoUrl, imageFormat: ImageFormat.JPEG, quality: 100);
  //   return file;
  // }
  //
  // static Widget _buildThumbnailImageChatDetail(String thumbnailData) {
  //   return Stack(children: [
  //     Image.file(
  //       key: UniqueKey(),
  //       File(thumbnailData),
  //       fit: BoxFit.cover,
  //       errorBuilder:
  //           (BuildContext context, Object exception, StackTrace? stackTrace) {
  //         return SvgPicture.asset(
  //           Images.default_ic,
  //           key: UniqueKey(),
  //           fit: BoxFit.cover,
  //         );
  //       },
  //     ),
  //     Positioned(
  //       top: 0,
  //       left: 0,
  //       right: 0,
  //       bottom: 0,
  //       child: Center(
  //         child: Container(
  //             padding: const EdgeInsets.all(10),
  //             decoration: const BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 color: Color.fromRGBO(255, 255, 255, 0.3)),
  //             child: const Icon(Icons.play_arrow_rounded,
  //                 color: Color.fromRGBO(255, 255, 255, 0.8))),
  //       ),
  //     )
  //   ]);
  // }

  static Widget _buildThumbnailImageProfile(String thumbnailData) {
    return Stack(children: [
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Image.file(
          key: UniqueKey(),
          File(thumbnailData),
          fit: BoxFit.cover,
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return SvgPicture.asset(
             'asset/images/default.svg',
              key: UniqueKey(),
              fit: BoxFit.cover,
            );
          },
        ),
      ),
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(255, 255, 255, 0.3)),
              child: const Icon(Icons.play_arrow_rounded,
                  color: Color.fromRGBO(255, 255, 255, 0.8))),
        ),
      )
    ]);
  }

  //show image
  static showImage(
      {required String url,
        double? height,
        double? width,
        BoxFit? fit,
        Widget? errorWidget}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      cacheKey: url,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) {
        return errorWidget ??
            SvgPicture.asset(
              'asset/images/default.svg',
              key: UniqueKey(),
              fit: BoxFit.cover,
              width: width,
              height: height,
            );
      },
    );
  }
}
