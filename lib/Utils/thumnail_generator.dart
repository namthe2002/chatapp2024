import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

import '../core/constant/theme/ThemeStyle.dart';

class ThumbnailRequest {
  const ThumbnailRequest({
    required this.video,
    required this.thumbnailPath,
    required this.imageFormat,
    required this.maxHeight,
    required this.maxWidth,
    required this.timeMs,
    required this.quality,
    required this.attachHeaders,
  });

  final String video;
  final String? thumbnailPath;
  final ImageFormat imageFormat;
  final int maxHeight;
  final int maxWidth;
  final int timeMs;
  final int quality;
  final bool attachHeaders;
}

class ThumbnailResult {
  const ThumbnailResult({
    required this.image,
    required this.dataSize,
    required this.height,
    required this.width,
  });

  final Image image;
  final int dataSize;
  final int height;
  final int width;
}

Future<ThumbnailResult> genThumbnail(ThumbnailRequest r) async {
  final cacheManager = DefaultCacheManager();
  final cacheKey = r.video + r.timeMs.toString(); // Unique key for each thumbnail
  final cachedFile = await cacheManager.getFileFromCache(cacheKey);

  if (cachedFile != null) {
    final bytes = await cachedFile.file.readAsBytes();
    final image = Image.memory(bytes);
    return ThumbnailResult(
      image: image,
      dataSize: bytes.length,
      height: r.maxHeight,
      width: r.maxWidth,
    );
  }

  Uint8List bytes;
  if (r.thumbnailPath != null) {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: r.video,
      headers: r.attachHeaders ? {'USERHEADER1': 'user defined header1'} : null,
      thumbnailPath: r.thumbnailPath,
      imageFormat: r.imageFormat,
      maxHeight: r.maxHeight,
      maxWidth: r.maxWidth,
      timeMs: r.timeMs,
      quality: r.quality,
    );
    bytes = await thumbnailFile.readAsBytes();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
      video: r.video,
      headers: r.attachHeaders ? {'USERHEADER1': 'user defined header1'} : null,
      imageFormat: r.imageFormat,
      maxHeight: r.maxHeight,
      maxWidth: r.maxWidth,
      timeMs: r.timeMs,
      quality: r.quality,
    );
  }

  await cacheManager.putFile(cacheKey, bytes);
  final image = Image.memory(bytes);
  final completer = Completer<ThumbnailResult>();

  image.image.resolve(ImageConfiguration.empty).addListener(
        ImageStreamListener(
          (ImageInfo info, bool _) {
            completer.complete(
              ThumbnailResult(
                image: image,
                dataSize: bytes.length,
                height: info.image.height,
                width: info.image.width,
              ),
            );
          },
          onError: completer.completeError,
        ),
      );

  return completer.future;
}

class GenThumbnailImage extends StatefulWidget {
  const GenThumbnailImage({
    Key? key,
    required this.thumbnailRequest,
    required this.videoUrl,
  }) : super(key: key);

  final ThumbnailRequest thumbnailRequest;
  final String videoUrl;

  @override
  State<GenThumbnailImage> createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  late Future<ThumbnailResult> _thumbnailFuture;
  final Map<String, Duration> timeVideoCache = {};

  @override
  void initState() {
    super.initState();
    // Cache the thumbnail once in the state
    _thumbnailFuture = genThumbnail(widget.thumbnailRequest);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: _thumbnailFuture, // Use the cached future
      builder: (BuildContext context, AsyncSnapshot<ThumbnailResult> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final image = data.image;
          return Stack(
            children: [
              Container(
                width: Get.width * 0.15,
                height: Get.height * 0.3,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: image,
                ),
              ),
              // Play/Stop button overlay in the center
              Positioned.fill(
                child: Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 50,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _timeVideo(url: widget.videoUrl), // Replace with actual duration
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: Text(
              'Error:\n${snapshot.error}\n\n${snapshot.stackTrace}',
            ),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String result = '$twoDigitMinutes:$twoDigitSeconds';

    if (duration.inHours > 0) {
      String twoDigitHours = twoDigits(duration.inHours);
      result = '$twoDigitHours:$result';
    }
    return result;
  }

  Future<Duration> timePlayer(String url) async {
    Completer<Duration> completer = Completer<Duration>();

    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      completer.complete(duration);
    });

    await audioPlayer.setSourceUrl(url);
    await audioPlayer.getDuration();
    return completer.future;
  }

  _timeVideo({required String url}) {
    if (timeVideoCache.containsKey(url)) {
      return Text(
        formatDuration(timeVideoCache[url]!),
        style: AppTextStyle.regularW400(size: 12, color: Colors.white),
      );
    }
    return FutureBuilder<Duration>(
      future: timePlayer(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          timeVideoCache[url] = snapshot.data!;
          return Text(
            formatDuration(snapshot.data!),
            style: AppTextStyle.regularW400(size: 12, color: Colors.white),
          );
        } else {
          return Text(
            '00:00',
            style: AppTextStyle.regularW400(size: 12, color: Colors.white),
          );
        }
      },
    );
  }
}
