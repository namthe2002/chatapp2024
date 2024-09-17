import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

Future<List<double>> parseWavFromUrl(String url,
    {int totalSamples = 68}) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception('Failed to load audio data');
  }

  final Uint8List audioData = response.bodyBytes;

  final List<int> rawSamples = extractRawSamples(audioData);

  List<int> filteredData = [];
  final double blockSize = rawSamples.length / totalSamples;

  for (int i = 0; i < totalSamples; i++) {
    final double blockStart = blockSize * i;
    int sum = 0;

    for (int j = 0; j < blockSize; j++) {
      sum += rawSamples[(blockStart + j).toInt()].toInt();
    }

    filteredData.add((sum / blockSize).round().toInt());
  }

  final maxNum = filteredData.reduce((a, b) => math.max(a.abs(), b.abs()));
  final double multiplier = math.pow(maxNum, -1).toDouble();
  final List<double> samples =
      filteredData.map<double>((e) => (e * multiplier)).toList();
  return samples;
}

int getSampleRate(Uint8List audioData) {
  return audioData.buffer.asByteData().getUint32(24, Endian.little);
}

List<int> extractRawSamples(Uint8List audioData) {
  final int dataStartIndex = 44;
  final List<int> samples = [];
  for (int i = dataStartIndex; i < audioData.length; i += 2) {
    final sample = audioData.buffer.asByteData().getInt16(i, Endian.little);
    samples.add(sample);
  }
  return samples;
}

// class WaveformCustomizations {
//   WaveformCustomizations({
//     required this.height,
//     required this.width,
//     this.activeColor = Colors.red,
//     this.inactiveColor = Colors.blue,
//     this.activeGradient,
//     this.inactiveGradient,
//     this.style = PaintingStyle.stroke,
//     this.showActiveWaveform = true,
//     this.absolute = false,
//     this.invert = false,
//     this.borderWidth = 1.0,
//     this.activeBorderColor = Colors.white,
//     this.inactiveBorderColor = Colors.white,
//     this.isRoundedRectangle = false,
//     this.isCentered = false,
//   });
//
//   double height;
//   double width;
//   Color inactiveColor;
//   Gradient? inactiveGradient;
//   bool invert;
//   bool absolute;
//   Color activeColor;
//   Gradient? activeGradient;
//   bool showActiveWaveform;
//   PaintingStyle style;
//   double borderWidth;
//   Color activeBorderColor;
//   Color inactiveBorderColor;
//   bool isRoundedRectangle;
//   bool isCentered;
// }
