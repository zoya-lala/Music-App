import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/widgets/waveform_visualizer.dart';

class MusicApp extends StatefulWidget {
  const MusicApp({super.key});

  @override
  State<MusicApp> createState() => _MusicAppState();
}

class _MusicAppState extends State<MusicApp> {
  final String audioUrl =
      'https://codeskulptor-demos.commondatastorage.googleapis.com/descent/background%20music.mp3';

  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(audioUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playOrPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/Rectangle 20.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              width: 434.0,
              height: 300.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instant Crush',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ft. Julian Casablancas',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    StreamBuilder<Duration>(
                      stream: _audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        final totalDuration =
                            _audioPlayer.duration ?? Duration.zero;
                        final progress = position.inMilliseconds /
                            (totalDuration.inMilliseconds > 0
                                ? totalDuration.inMilliseconds
                                : 1);

                        return GestureDetector(
                          onHorizontalDragUpdate: (details) {
                            final dragProgress =
                                details.localPosition.dx / context.size!.width;
                            final seekPosition = Duration(
                                milliseconds: (dragProgress *
                                        totalDuration.inMilliseconds)
                                    .toInt());
                            _audioPlayer.seek(seekPosition);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 80.0,
                            child: CustomPaint(
                              painter: WaveformVisualizer(progress),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: StreamBuilder<Duration>(
                        stream: _audioPlayer.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          return Text(
                            formatDuration(position),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: _playOrPause,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
