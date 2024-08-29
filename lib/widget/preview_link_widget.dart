import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' show PreviewData;

class PreviewWebLink extends StatefulWidget {
  final String url; // Thêm thuộc tính URL

  const PreviewWebLink({super.key, required this.url});

  @override
  State<PreviewWebLink> createState() => _PreviewWebLinkState();
}

class _PreviewWebLinkState extends State<PreviewWebLink> {
  PreviewData? _previewData; // Lưu trữ PreviewData

  @override
  Widget build(BuildContext) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    String proxiedUrl = 'https://thingproxy.freeboard.io/fetch/${widget.url}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Color(0xfff7f7f8),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          child: LinkPreview(
            enableAnimation: true,
            onPreviewDataFetched: (data) {
              setState(() {
                _previewData = data;
              });
            },
            corsProxy: 'https://thingproxy.freeboard.io/fetch/',
            previewData: _previewData,
            text: widget.url,
            width: MediaQuery.of(context).size.width,
            imageBuilder: (imageUrl) {
              return Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              );
            },
          ),
        ),
      ),
    );
  }
}
