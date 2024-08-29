import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
  File? file;

  late PlayerController playerController;
  late StreamSubscription<PlayerState> playerStateSubscription;
  late Directory directory;

  final playerWaveStyle = const PlayerWaveStyle(
      fixedWaveColor: Color.fromRGBO(146, 154, 169, 1),
      liveWaveColor: Color.fromRGBO(17, 185, 145, 1),
      scaleFactor: 200);

  late ap.AudioPlayer _audioPlayer;
  Duration _totalDuration = Duration();

  @override
  void didUpdateWidget(covariant ChatBubbleAudio oldWidget) {
    if (widget.url != oldWidget.url ||
        widget.index != oldWidget.index ||
        widget.width != oldWidget.width) {
      _preparePlayer(widget.url, widget.index, widget.width);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    playerController = PlayerController();
    _preparePlayer(widget.url, widget.index, widget.width);
    playerStateSubscription = playerController.onPlayerStateChanged.listen((_) {
      setState(() {});
    });

    _audioPlayer = ap.AudioPlayer();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    await _audioPlayer.setSourceUrl(widget.url);
  }

  String _formatDuration(Duration duration) {
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

  void _preparePlayer(String url, String index, double width) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        directory = await getTemporaryDirectory();
        file = File(
            '${directory.path}/example${index}${Platform.isAndroid ? '.mp3' : '.wav'}');
        await file!.writeAsBytes((response.bodyBytes));

        await playerController.preparePlayer(
          path: file!.path,
          shouldExtractWaveform: false,
        );

        playerController
            .extractWaveformData(
              path: file!.path,
              noOfSamples: playerWaveStyle.getSamplesForWidth(width),
            )
            .then((waveformData) => debugPrint(waveformData.toString()));
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    playerStateSubscription.cancel();
    playerController.dispose();

    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!playerController.playerState.isStopped)
          GestureDetector(
            onTap: () async {
              playerController.playerState.isPlaying
                  ? await playerController.pausePlayer()
                  : await playerController.startPlayer(
                      finishMode: FinishMode.pause,
                    );
            },
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(17, 185, 145, 1)),
              child: Icon(
                playerController.playerState.isPlaying
                    ? Icons.stop_rounded
                    : Icons.play_arrow_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        SizedBox(
          width: 8,
        ),
        AudioFileWaveforms(
          size: Size(widget.width, 30),
          playerController: playerController,
          waveformType: WaveformType.fitWidth,
          playerWaveStyle: playerWaveStyle,
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
            child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Get.isDarkMode
                ? Color.fromRGBO(152, 152, 152, 1.0)
                : Color.fromRGBO(228, 230, 236, 1),
          ),
          child: Text(
            '${_formatDuration(_totalDuration)}',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
        ))
      ],
    );
  }
}
