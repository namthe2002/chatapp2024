import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class MediaChatDetailController extends GetxController {
  String urlString = '';
  RxBool isLoading = true.obs;
  VideoPlayerController? playerController;
  RxBool isPlaying = true.obs;

  @override
  void onReady() async {
    super.onReady();
    urlString = Get.arguments;
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    playerController?.dispose();
  }

  Future<void> saveImage(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      String fileName = Uri.parse(imageUrl).pathSegments.last;
      String filePath = '$tempPath/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      // Lưu ảnh vào thư viện ảnh
      final result = await ImageGallerySaver.saveFile(filePath);

      if (result['isSuccess']) {
        Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('photo_saved_successfully'));
      } else {
        Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('photo_saved_error'));
      }
    } else {
      Utils.showSnackBar(title: TextByNation.getStringByKey('notification'), message: TextByNation.getStringByKey('error_delete_message'));
    }
  }
}

