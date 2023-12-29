import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/assets.dart';
import 'package:video_player/video_player.dart';

class BrowseHeader extends StatefulWidget {
  const BrowseHeader({super.key});

  @override
  State<BrowseHeader> createState() => _BrowseHeaderState();
}

class _BrowseHeaderState extends State<BrowseHeader> {
  bool _isMuted = true;

  //
  // late final VideoPlayerController _videoController = VideoPlayerController.networkUrl(
  //   Uri.parse(
  //     Assets.violetEvergardenOnlineVideoUrl,
  //   ),
  // )
  //   ..initialize().then((_) => setState(() {}))
  //   ..setVolume(0)
  //   ..play();

  late final VideoPlayerController _videoController = VideoPlayerController.asset(
    Assets.violetEvergardenOfflineVideoUrl,
  )
    ..initialize().then((_) => setState(() {}))
    ..setVolume(0)
    ..play();

  late final screenSize = MediaQuery.sizeOf(context);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _videoController.value.isPlaying
          ? _videoController.pause()
          : _videoController.play(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          AspectRatio(
            aspectRatio: _videoController.value.isInitialized
                ? _videoController.value.aspectRatio
                : 16 / 9,
            child: _videoController.value.isInitialized
                ? VideoPlayer(_videoController)
                : Image.asset(
                    Assets.violetEvergardenBackdropPath,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: AspectRatio(
              aspectRatio: _videoController.value.isInitialized
                  ? _videoController.value.aspectRatio
                  : 16 / 9,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 60.0,
            bottom: min(
              30,
              min(screenSize.width * 0.25, screenSize.height * 0.25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  Assets.violetEvergardenTitle,
                  width: 350,
                ),
                const Gap(20),
                SizedBox(
                  width: screenSize.width * 0.5,
                  child: const Text(
                    Assets.violetEvergardenDecs,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2.0, 4.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      onPressed: () => print('Play'),
                      icon: const Icon(Icons.play_arrow_rounded, size: 30.0),
                      label: const Text(
                        'Play',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withAlpha(80),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                      onPressed: () => print('More Info'),
                      icon: const Icon(Icons.info_outline, size: 30.0),
                      label: const Text(
                        'Thông tin khác',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    if (_videoController.value.isInitialized)
                      IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                        ),
                        color: Colors.white,
                        iconSize: 30.0,
                        onPressed: () => setState(() {
                          _isMuted
                              ? _videoController.setVolume(100)
                              : _videoController.setVolume(0);
                          _isMuted = _videoController.value.volume == 0;
                        }),
                      ).animate().fade(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
