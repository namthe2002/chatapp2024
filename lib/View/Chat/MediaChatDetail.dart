import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/MediaChatDetailController.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaChatDetail extends StatefulWidget {
  MediaChatDetail({Key? key}) : super(key: key);

  @override
  State<MediaChatDetail> createState() => _MediaChatDetailState();
}

class _MediaChatDetailState extends State<MediaChatDetail> {
  Size size = const Size(0, 0);

  final controller = Get.put(MediaChatDetailController());

  @override
  void dispose() {
    Get.delete<MediaChatDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: IconButton(
            onPressed: () {
              Get.delete<MediaChatDetailController>();
              return Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 42,
            )),
        leadingWidth: 70,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await controller.saveFile(controller.urlString);
            },
            icon: Icon(
              Icons.download_outlined,
              size: 42,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Obx(() => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : Utils.getFileType(controller.urlString) == 'Video'
                ? _videoPlay()
                : _viewPhoto()),
      ),
    );
  }

  _viewPhoto() {
    return Stack(
      children: [
        PhotoViewGallery.builder(
          itemCount: 1,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(controller.urlString),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
            );
          },
          backgroundDecoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  _videoPlay() {
    controller.videoController = CachedVideoPlayerPlusController.networkUrl(Uri.parse(controller.urlString))
      ..initialize().then((_) {
        controller.videoController!.play();
        controller.videoController!.setLooping(true);
        controller.update();
      });
    return GestureDetector(
      onTap: () {
        if (controller.isPlaying.value) {
          controller.videoController!.pause();
        } else {
          controller.videoController!.play();
        }
        controller.isPlaying.value = !controller.isPlaying.value;
      },
      child: GetBuilder<MediaChatDetailController>(
        builder: (controller) {
          if (controller.videoController!.value.isInitialized) {
            final videoWidth = controller.videoController!.value.size.width;
            final videoHeight = controller.videoController!.value.size.height;
            return Stack(
              children: [
                Positioned.fill(
                    child: AspectRatio(
                  aspectRatio: controller.videoController!.value.aspectRatio,
                  child: Stack(
                    children: [
                      CachedVideoPlayerPlus(controller.videoController!),
                      Align(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: Icon(
                            controller.videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            if (controller.videoController!.value.isPlaying) {
                              controller.videoController!.pause();
                            } else {
                              controller.videoController!.play();
                            }
                          },
                        ),
                      ),

                      // Thanh tua video
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: VideoProgressIndicator(
                          controller.videoController!,
                          allowScrubbing: true,
                          colors: VideoProgressColors(
                            playedColor: Colors.red,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: Get.width / 4,
                        child: IconButton(
                          icon: Icon(Icons.fast_forward, color: Colors.white, size: 30),
                          onPressed: () {
                            final position = controller.videoController!.value.position;
                            final duration = controller.videoController!.value.duration;
                            if (position + Duration(seconds: 5) < duration) {
                              controller.videoController!.seekTo(position + Duration(seconds: 5));
                            } else {
                              controller.videoController!.seekTo(duration);
                            }
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: Get.width / 4,
                        child: IconButton(
                          icon: Icon(Icons.fast_rewind, color: Colors.white, size: 30),
                          onPressed: () {
                            final position = controller.videoController!.value.position;
                            if (position - Duration(seconds: 5) > Duration.zero) {
                              controller.videoController!.seekTo(position - Duration(seconds: 5));
                            } else {
                              controller.videoController!.seekTo(Duration.zero);
                            }
                          },
                        ),
                      ),
                      // Positioned(
                      //   top: 0,
                      //   left: 0,
                      //   right: 0,
                      //   bottom: 0,
                      //   child: Obx(() => controller.isPlaying.value
                      //       ? Container()
                      //       : Icon(
                      //     Icons.play_arrow_rounded,
                      //     color: Colors.white54,
                      //     size: 60,
                      //   )),
                      // ),
                    ],
                  ),
                )),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
