import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Chat/MediaChatDetailController.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class MediaChatDetail extends StatelessWidget {
  MediaChatDetail({Key? key}) : super(key: key);

  Size size = const Size(0, 0);

  final controller = Get.put(MediaChatDetailController());

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<MediaChatDetailController>();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await controller.saveImage(controller.urlString);
              },
              icon: Icon(
                Icons.download_outlined,
              ),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          child: Obx(() => controller.isLoading.value ? Center(
              child: CircularProgressIndicator()
          ) : Utils.getFileType(controller.urlString) == 'Video' ?
          _videoPlay() : _viewPhoto()),
        ),
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
    controller.playerController  = VideoPlayerController.networkUrl(Uri.parse(controller.urlString))
      ..initialize().then((_) {
        controller.playerController!.play();
        controller.playerController!.setLooping(true);
        controller.update();
      });
    return GestureDetector(
      onTap: () {
        if (controller.isPlaying.value) {
          controller.playerController!.pause();
        } else {
          controller.playerController!.play();
        }
        controller.isPlaying.value = !controller.isPlaying.value;
      },
      child: GetBuilder<MediaChatDetailController>(
        builder: (controller) {
          if (controller.playerController!.value.isInitialized) {
            final videoWidth = controller.playerController!.value.size.width;
            final videoHeight = controller.playerController!.value.size.height;
            return Stack(
              children: [
                Center(
                  child: videoWidth / videoHeight < 1.0 ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoWidth,
                        height: videoHeight,
                        child: VideoPlayer(controller.playerController!),
                      ),
                    ),
                  ) :
                  AspectRatio(
                    aspectRatio: controller.playerController!.value.aspectRatio,
                    child: VideoPlayer(controller.playerController!),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Obx(() => controller.isPlaying.value ? Container() : Icon(Icons.play_arrow_rounded, color: Colors.white54, size: 60,)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: VideoProgressIndicator(
                    controller.playerController!,
                    allowScrubbing: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white12,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }

}