import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

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
  Uint8List bytes;
  final completer = Completer<ThumbnailResult>();
  if (r.thumbnailPath != null) {
    final thumbnailFile = await VideoThumbnail.thumbnailFile(
      video: r.video,
      headers: r.attachHeaders
          ? const {
        'USERHEADER1': 'user defined header1',
        'USERHEADER2': 'user defined header2',
      }
          : null,
      thumbnailPath: r.thumbnailPath,
      imageFormat: r.imageFormat,
      maxHeight: r.maxHeight,
      maxWidth: r.maxWidth,
      timeMs: r.timeMs,
      quality: r.quality,
    );

    debugPrint('thumbnail file is located: $thumbnailFile');

    bytes = await thumbnailFile.readAsBytes();
  } else {
    bytes = await VideoThumbnail.thumbnailData(
      video: r.video,
      headers: r.attachHeaders
          ? const {
        'USERHEADER1': 'user defined header1',
        'USERHEADER2': 'user defined header2',
      }
          : null,
      imageFormat: r.imageFormat,
      maxHeight: r.maxHeight,
      maxWidth: r.maxWidth,
      timeMs: r.timeMs,
      quality: r.quality,
    );
  }

  final imageDataSize = bytes.length;
  debugPrint('image size: $imageDataSize');

  final image = Image.memory(bytes);
  image.image.resolve(ImageConfiguration.empty).addListener(
    ImageStreamListener(
          (ImageInfo info, bool _) {
        completer.complete(
          ThumbnailResult(
            image: image,
            dataSize: imageDataSize,
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
  }) : super(key: key);

  final ThumbnailRequest thumbnailRequest;

  @override
  State<GenThumbnailImage> createState() => _GenThumbnailImageState();
}

class _GenThumbnailImageState extends State<GenThumbnailImage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ThumbnailResult>(
      future: genThumbnail(widget.thumbnailRequest),
      builder: (BuildContext context, AsyncSnapshot<ThumbnailResult> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          final image = data.image;
          final width = data.width;
          final height = data.height;
          final dataSize = data.dataSize;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(color: Colors.grey),
              image,
            ],
          );
        } else if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(8),
            color: Colors.red,
            child: Text('Error:\n${snapshot.error}\n\n${snapshot.stackTrace}'),
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }
}
