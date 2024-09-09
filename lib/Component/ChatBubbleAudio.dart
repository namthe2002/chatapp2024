import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
// import 'package:waveform/waveform.dart';
import 'package:waveform_flutter/waveform_flutter.dart';

class ChatBubbleAudio extends StatefulWidget {
  final String url;
  final String index;
  final double width;

  const ChatBubbleAudio({
    Key? key,
    required this.url,
    required this.index,
    required this.width,
  }) : super(key: key);

  @override
  State<ChatBubbleAudio> createState() => WaveBubbleState();
}

class WaveBubbleState extends State<ChatBubbleAudio> {
  late AudioPlayer _audioPlayer;
  Duration _totalDuration = Duration();
  Duration _currentPosition = Duration();
  late StreamSubscription<PlayerState> playerStateSubscription;
  late Stream<Amplitude> _amplitudeStream;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initPlayer();
    // _amplitudeStream = _createAmplitudeStream();
  }

  Future<void> _initPlayer() async {
    try {
      await _audioPlayer.setUrl(widget.url);

      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _totalDuration = duration ?? Duration();
        });
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _currentPosition = Duration.zero;
            _audioPlayer.stop();
          });
          _audioPlayer.seek(Duration.zero);
        }
      });
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  // Stream<Amplitude> _createAmplitudeStream() {
  //   return Stream.periodic(Duration(milliseconds: 50), (count) {
  //     final position = _currentPosition.inMilliseconds;
  //     final total = _totalDuration.inMilliseconds;
  //     if (total == 0) return Amplitude(0);
  //     return Amplitude((position / total).clamp(0.0, 1.0), current: null);
  //   });
  // }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (_audioPlayer.playing) {
              await _audioPlayer.pause();
            } else {
              await _audioPlayer.play();
            }
          },
          child: Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(17, 185, 145, 1),
            ),
            child: Icon(
             _audioPlayer.playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 8),
        // Expanded(
        //   child: SizedBox(
        //     height: 30,
        //     child: AnimatedWaveList(
        //       stream: _amplitudeStream,
        //       width: widget.width,
        //       height: 30,
        //       inactiveColor: Colors.grey,
        //       activeColor: Colors.lightGreen,
        //       maxDuration: _totalDuration,
        //     ),
        //   ),
        // ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Get.isDarkMode
                ? Color.fromRGBO(152, 152, 152, 1.0)
                : Color.fromRGBO(228, 230, 236, 1),
          ),
          child: Text(
            '${_formatDuration(_currentPosition)} / ${_formatDuration(_totalDuration)}',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
