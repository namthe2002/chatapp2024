import 'dart:async';
import 'package:flutter/material.dart';

class RecordingTimer extends StatefulWidget {
  @override
  _RecordingTimerState createState() => _RecordingTimerState();
}

class _RecordingTimerState extends State<RecordingTimer> {
  late Timer _timer;
  int _milliseconds = 0;
  bool _isRecording = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_isRecording) {
        setState(() {
          _milliseconds += 100;
        });
      }
    });
  }

  String formatRecordingTime(int milliseconds) {
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    final remainingMilliseconds = (milliseconds % 1000) ~/ 100; // Chỉ hiển thị phần nhỏ giây
    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toString().padLeft(2, '0')},'
        '$remainingMilliseconds';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Dấu chấm đỏ ẩn hiện
        AnimatedOpacity(
          opacity: _milliseconds % 1000 < 500 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Icon(
            Icons.circle,
            color: Colors.red,
            size: 12,
          ),
        ),
        SizedBox(width: 8),
        // Hiển thị thời gian ghi âm
        Text(
          formatRecordingTime(_milliseconds),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
