import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:live_yoko/Component/WaveAudioForm.dart';
// import 'package:waveform/waveform.dart';

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
  bool _isAudioLoaded = false;
  late StreamSubscription<PlayerState> playerStateSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadAudioMetadata();
  }

  Future<void> _loadAudioMetadata() async {
    try {
      // Chỉ tải metadata mà không phát âm thanh
      await _audioPlayer.setUrl(widget.url, preload: false);
      _totalDuration = (await _audioPlayer.load()) ?? Duration(); // Lấy thời lượng
      setState(() {});
    } catch (e) {
      print("Error loading audio metadata: $e");
    }
  }


  Future<void> _playAudio() async {
    if (!_isAudioLoaded) {
      try {
        await _audioPlayer.setUrl(widget.url);
        _isAudioLoaded = true;
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
        print("Error loading audio for playback: $e");
        return;
      }
    }

    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

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
            await _playAudio(); // Chỉ tải và phát khi nhấn
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
        AudioWaveformScreen(audioUrl: widget.url, timeAudio: _totalDuration),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Get.isDarkMode ? Color.fromRGBO(152, 152, 152, 1.0) : Color.fromRGBO(228, 230, 236, 1),
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
