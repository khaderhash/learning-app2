import 'package:flutter/material.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:video_player/video_player.dart';

class LessonVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const LessonVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _LessonVideoPlayerState createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    String correctedUrl = widget.videoUrl;

    if (GetPlatform.isAndroid) {
      correctedUrl = correctedUrl.replaceAll('127.0.0.1', '10.0.2.2');
      correctedUrl = correctedUrl.replaceAll('localhost', '10.0.2.2');
    }

    print("🎬 Trying to play video from URL: $correctedUrl");

    _controller = VideoPlayerController.networkUrl(Uri.parse(correctedUrl))
      ..initialize().then((_) {
        print("✅ Video initialized successfully!");
        setState(() {});
      }).catchError((error) {
        print("❌ Video Player Initialization Error: $error");
      });

    _controller.addListener(() {
      if (!mounted) return;

      if (_controller.value.hasError) {
        print("⚠️ Video Player Error: ${_controller.value.errorDescription}");
      }

      if (_isPlaying != _controller.value.isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  VideoPlayer(_controller),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                    child: AnimatedOpacity(
                      opacity: _isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        color: Colors.black26,
                        child: const Icon(
                          Icons.play_arrow,
                          size: 70.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
