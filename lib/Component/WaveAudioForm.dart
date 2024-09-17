import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:get/get.dart';
import 'dart:async'; // For Timer
import '../Global/ColorValue.dart';
import 'SetSamples.dart'; // Your custom parser for getting audio samples

class AudioWaveformScreen extends StatefulWidget {
  final String audioUrl;
  final Duration timeAudio;

  AudioWaveformScreen({
    required this.audioUrl,
    required this.timeAudio,
  });

  @override
  _AudioWaveformScreenState createState() => _AudioWaveformScreenState();
}

class _AudioWaveformScreenState extends State<AudioWaveformScreen> {
  late List<double> audioSamples = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Show a loading indicator
      setState(() {
        isLoading = true;
      });
      audioSamples = await parseWavFromUrl(widget.audioUrl, totalSamples: 55);
      setState(() {
        isLoading = false;
      });
      print("Loading audio: ${audioSamples.length}");
    } catch (e) {
      print("Error loading audio: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child:  SizedBox.shrink(),
          )
        : audioSamples.isEmpty
            ? SizedBox.shrink()
            : Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 0.2, color: ColorValue.colorPrimary),
                  borderRadius: BorderRadius.circular(12),
                  color: ColorValue.white.withOpacity(0.3),
                ),
                child: SquigglyWaveform(
                  samples: audioSamples,
                  width: Get.width / 12,
                  height: 25,
                  inactiveColor: ColorValue.colorPrimary,
                  strokeWidth: 1,
                  // absolute: true,
                ),
              );
  }
}
