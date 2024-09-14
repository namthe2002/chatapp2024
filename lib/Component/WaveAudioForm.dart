import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:live_yoko/Global/ColorValue.dart'; // để sử dụng compute

Future<Uint8List> fetchAudioFile(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load audio file');
  }
}

class ExtractAudioSamplesParams {
  final Uint8List data;
  final int downsampleFactor;

  ExtractAudioSamplesParams(this.data, this.downsampleFactor);
}

List<double> extractAndDownsampleAudioSamples(
    ExtractAudioSamplesParams params) {
  List<double> samples = [];
  Uint8List data = params.data;
  int downsampleFactor = params.downsampleFactor;

  String chunkID = String.fromCharCodes(data.sublist(0, 4)); // "RIFF"
  String format = String.fromCharCodes(data.sublist(8, 12)); // "WAVE"

  if (chunkID != "RIFF" || format != "WAVE") {
    throw Exception("Unsupported file format");
  }

  int bitsPerSample = data.buffer.asByteData().getUint16(34, Endian.little);
  int dataStartIndex = 44;
  int bytesPerSample = bitsPerSample ~/ 8;

  for (int i = dataStartIndex;
      i < data.length;
      i += bytesPerSample * downsampleFactor) {
    if (bitsPerSample == 16) {
      int sampleValue = data.buffer.asByteData().getInt16(i, Endian.little);
      double normalizedSample = sampleValue / 32768.0;
      samples.add(normalizedSample);
    }
  }

  return samples;
}

// Giảm số lượng mẫu (Downsample)
List<double> downsample(List<double> samples, int factor) {
  List<double> downsampled = [];
  for (int i = 0; i < samples.length; i += factor) {
    downsampled.add(samples[i]);
  }
  return downsampled;
}

// Tính toán mẫu âm thanh trong nền
Future<List<double>> extractAndDownsampleAudioSamplesInBackground(
    Uint8List data, int downsampleFactor) async {
  return compute(
    (ExtractAudioSamplesParams params) =>
        extractAndDownsampleAudioSamples(params),
    ExtractAudioSamplesParams(data, downsampleFactor),
  );
}

// Chuẩn hóa các mẫu âm thanh
List<double> normalizeSamples(List<double> samples) {
  double maxSample =
      samples.map((e) => e.abs()).reduce((a, b) => a > b ? a : b);
  return samples.map((e) => e / maxSample).toList();
}

// Widget vẽ sóng âm thanh
class WaveformPainter extends CustomPainter {
  final List<double> audioSamples;

  WaveformPainter(this.audioSamples);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorValue.colorPrimary // Or any other color you prefer
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    double yCenter = size.height / 2;
    double xStep =
        size.width / (audioSamples.length - 1); // Khoảng cách giữa các điểm mẫu

    path.moveTo(0, yCenter);

    for (int i = 0; i < audioSamples.length; i++) {
      double x = i * xStep;
      double y = yCenter - audioSamples[i] * (size.height / 2);

      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class WaveformWidget extends StatelessWidget {
  final List<double> audioSamples;

  WaveformWidget(this.audioSamples);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: Get.width / 10,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(width: 0.2, color: ColorValue.colorPrimary),
        borderRadius: BorderRadius.circular(12),
        color: ColorValue.white.withOpacity(0.3),
      ),
      child: RepaintBoundary(
        child: CustomPaint(
          painter: WaveformPainter(audioSamples),
        ),
      ),
    );
  }
}

class AudioWaveformScreen extends StatefulWidget {
  final String audioUrl;
  final Duration timeAudio;

  AudioWaveformScreen({required this.audioUrl, required this.timeAudio});

  @override
  _AudioWaveformScreenState createState() => _AudioWaveformScreenState();
}

class _AudioWaveformScreenState extends State<AudioWaveformScreen> {
  List<double> audioSamples = [];
  int downSampleInt = 1000;

  @override
  void initState() {
    super.initState();
    _setDownSampleInt();
    fetchAudioFile(widget.audioUrl).then((data) {
      extractAndDownsampleAudioSamplesInBackground(data, downSampleInt)
          .then((samples) {
        setState(() {
          audioSamples =
              normalizeSamples(samples); // Chuẩn hóa các mẫu âm thanh
        });
      });
    });
  }

  void _setDownSampleInt() {
    if (widget.timeAudio < Duration(seconds: 30)) {
      downSampleInt = 2000;
    } else if (widget.timeAudio < Duration(minutes: 1)) {
      downSampleInt *= 4;
    } else if (widget.timeAudio < Duration(minutes: 2)) {
      downSampleInt *= 8;
    } else if (widget.timeAudio < Duration(minutes: 4)) {
      downSampleInt *= 16;
    } else if (widget.timeAudio < Duration(minutes: 8)) {
      downSampleInt *= 32;
    } else if (widget.timeAudio < Duration(minutes: 16)) {
      downSampleInt *= 64;
      // } else if (widget.timeAudio < Duration(minutes: 32)) {
      //   downSampleInt *= 128;
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return audioSamples.isEmpty
        ? SizedBox.shrink()
        : WaveformWidget(audioSamples);
  }
}
