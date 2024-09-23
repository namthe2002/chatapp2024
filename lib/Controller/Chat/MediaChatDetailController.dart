import 'dart:typed_data';

import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

import '../../Utils/enum.dart';



class MediaChatDetailController extends GetxController {
  String urlString = '';
  RxBool isLoading = true.obs;
  // VideoPlayerController? playerController;
  CachedVideoPlayerPlusController? videoController;

  RxBool isPlaying = true.obs;

  @override
  void onReady() async {
    super.onReady();
    urlString = Get.arguments;
    urlString = Get.arguments;
    isLoading.value = false;
    if(Utils.getFileType(urlString) == 'Video'){
      videoController = CachedVideoPlayerPlusController.networkUrl(
          Uri.parse(urlString), invalidateCacheIfOlderThan: const Duration(days: 10))
        ..initialize().then((_) {
          videoController!.play();
          videoController!.setLooping(false);
          update();
        });
    }
  }

  @override
  void onClose() {
    super.onClose();
    videoController?.dispose();
  }

  Future<void> saveFile(String fileUrl) async {
    http.Response response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      String fileName = Uri.parse(fileUrl).pathSegments.last;

      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", fileName)
        ..click();

      // Clean up
      html.Url.revokeObjectUrl(url);

      // Show success message
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('file_saved_successfully'),
        type: ToastType.SUCCESS,
      );
      // Utils.showSnackBar(
      //   title: TextByNation.getStringByKey('notification'),
      //   message: TextByNation.getStringByKey('file_saved_successfully'),
    } else {
      Utils.showToast(
        Get.overlayContext!,
        TextByNation.getStringByKey('error_delete_message'),
        type: ToastType.ERROR,
      );
      // Utils.showSnackBar(
      //   title: TextByNation.getStringByKey('notification'),
      //   message: TextByNation.getStringByKey('error_delete_message'),
      // );
    }
  }
}

