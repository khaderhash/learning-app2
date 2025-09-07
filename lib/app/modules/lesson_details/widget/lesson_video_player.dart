import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart'; // لاستخدام GetPlatform

class LessonVideoPlayer extends StatefulWidget {
  final String videoUrl;
  const LessonVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    print("🎬 Initializing video via download from: ${widget.videoUrl}");
    _initializeVideoPlayerFromFile();
  }

  Future<void> _initializeVideoPlayerFromFile() async {
    try {
      String correctedUrl = widget.videoUrl;
      if (GetPlatform.isAndroid) {
        correctedUrl = correctedUrl
            .replaceAll('127.0.0.1', '10.0.2.2')
            .replaceAll('localhost', '10.0.2.2');
      }

      // 1. تحميل الفيديو كـ bytes
      final response = await http.get(Uri.parse(correctedUrl));
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load video: Status code ${response.statusCode}',
        );
      }
      final bytes = response.bodyBytes;

      // 2. الحصول على مسار مؤقت وحفظ الملف
      final dir = await getTemporaryDirectory();
      // استخدم اسم ملف فريد لتجنب مشاكل التخزين المؤقت (caching)
      final fileName = Uri.parse(correctedUrl).pathSegments.last;
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      // 3. تهيئة مشغل الفيديو من الملف المحلي
      _controller = VideoPlayerController.file(file)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            _controller?.play();
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Failed to load video: ${e.toString()}";
          _isLoading = false;
        });
      }
      print("❌ Video Error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Loading video...'),
            ],
          ),
        ),
      );
    }
    if (_error != null || _controller == null) {
      return SizedBox(
        height: 200,
        child: Center(child: Text("⚠️ Error loading video")),
      );
    }

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }
}
