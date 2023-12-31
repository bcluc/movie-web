import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/assets.dart';

import 'package:movie_web/cubits/video_play_control/video_play_control.dart';
import 'package:movie_web/cubits/video_slider/video_slider_cubit.dart';
import 'package:movie_web/models/episode.dart';
import 'package:movie_web/models/season.dart';
import 'package:movie_web/widgets/film_detail/film_detail.dart';
import 'package:movie_web/widgets/video_player/control_buttons.dart';
import 'package:movie_web/widgets/video_player/slider_video.dart';
import 'package:movie_web/widgets/video_player/video_bottom_utils.dart';
import 'package:movie_web/widgets/video_player/volume_silder.dart';

import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.firstEpisodeToPlay,
  });

  final Episode firstEpisodeToPlay;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;

  bool _controlsOverlayVisible = false;
  // True, because when lock controls, Lock IconButton will raise

  late Timer _controlsTimer = Timer(Duration.zero, () {});

  late bool isMovie;

  late Episode _currentEpisode;

  void _toggleControlsOverlay() {
    _controlsTimer.cancel();

    setState(() {
      _controlsOverlayVisible = !_controlsOverlayVisible;
    });

    if (_controlsOverlayVisible) {
      // Hide the overlay after a delay
      _startCountdownToDismissControls();
    }
  }

  void _startCountdownToDismissControls() {
    _controlsTimer = Timer(const Duration(seconds: 4), () {
      setState(() {
        _controlsOverlayVisible = false;
      });
    });
  }

  void _onVideoPlayerPositionChanged() {
    context.read<VideoSliderCubit>().setProgress(_videoPlayerController.value.position.inMilliseconds / _videoPlayerController.value.duration.inMilliseconds);
  }

  void _onVideoPlayerStatusChanged() {
    _videoPlayerController.value.isPlaying ? context.read<VideoPlayControlCubit>().play() : context.read<VideoPlayControlCubit>().pause();
  }

  void setVideoController(Episode episode) {
    _controlsTimer.cancel();
    _currentEpisode = episode;

    setState(() {
      _controlsOverlayVisible = false;
    });

    // print('LOADING VIDEO FROM NETWORK');
    // _videoPlayerController = VideoPlayerController.networkUrl(
    //   Uri.parse(episode.linkEpisode),
    // );

    _videoPlayerController = VideoPlayerController.asset(
      Assets.violetEvergardenOfflineVideoUrl,
    );

    _videoPlayerController.initialize().then((value) {
      _videoPlayerController.addListener(_onVideoPlayerPositionChanged);
      _videoPlayerController.addListener(_onVideoPlayerStatusChanged);
      setState(() {
        _controlsOverlayVisible = true;
      });
      _videoPlayerController.play().then((_) => _startCountdownToDismissControls());
    });
  }

  @override
  void initState() {
    super.initState();

    isMovie = filmData['isMovie'];
    setVideoController(widget.firstEpisodeToPlay);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _controlsTimer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _videoPlayerController.value.isInitialized ? _toggleControlsOverlay : null,
        child: Stack(
          children: [
            /* Video */
            Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: _videoPlayerController.value.isInitialized ? _videoPlayerController.value.aspectRatio : 16 / 9,
                child: _videoPlayerController.value.isInitialized
                    ? VideoPlayer(_videoPlayerController)
                    : const Center(
                        child: CircularProgressIndicator(
                          strokeCap: StrokeCap.round,
                        ),
                      ),
              ),
            ),
            /* Controls Button */
            AnimatedOpacity(
              opacity: _controlsOverlayVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                height: double.infinity,
                child: IgnorePointer(
                  ignoring: !_controlsOverlayVisible,
                  child: ControlButtons(
                    _videoPlayerController,
                    _startCountdownToDismissControls,
                    () => _controlsTimer.cancel(),
                  ),
                ),
              ),
            ),
            /* Header */
            Positioned(
              top: 50,
              left: 50,
              right: 50,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: _controlsOverlayVisible ? 1 : 0,
                curve: Curves.easeInOut,
                child: IgnorePointer(
                  ignoring: !_controlsOverlayVisible,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Expanded(
                        child: Text(
                          _currentEpisode.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      )
                    ],
                  ),
                ),
              ),
            ),
            /* Volumn Slider */
            Positioned(
              left: 50,
              top: 0,
              bottom: 0,
              child: AnimatedOpacity(
                opacity: _controlsOverlayVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: VolumeSlider(
                  _videoPlayerController,
                  () => _startCountdownToDismissControls(),
                  () => _controlsTimer.cancel(),
                ),
              ),
            ),
            /* Bottom Utils */
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: AnimatedOpacity(
                opacity: _controlsOverlayVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: IgnorePointer(
                  ignoring: !_controlsOverlayVisible,
                  child: Column(
                    children: [
                      SliderVideo(
                        _controlsOverlayVisible,
                        _videoPlayerController,
                        _startCountdownToDismissControls,
                        () => _controlsTimer.cancel(),
                        () => _videoPlayerController.removeListener(_onVideoPlayerPositionChanged),
                        () => _videoPlayerController.addListener(_onVideoPlayerPositionChanged),
                      ),
                      const Gap(10),
                      VideoBottomUtils(
                        overlayVisible: _controlsOverlayVisible,
                        videoPlayerController: _videoPlayerController,
                        startCountdownToDismissControls: _startCountdownToDismissControls,
                        cancelTimer: () => _controlsTimer.cancel(),
                        currentEpisodeId: _currentEpisode.episodeId,
                        moveToEdpisode: (episode) {
                          /*
                            Remove Listener để không xảy ra lỗi
                            VD:
                            _onVideoPlayerPositionChanged sẽ kích hoạt cả khi _videoPlayerController bị destruct
                            Khi đó,
                            _videoPlayerController.value.duration.inMilliseconds = 0; => Lỗi
                            */
                          _videoPlayerController.removeListener(_onVideoPlayerPositionChanged);
                          _videoPlayerController.removeListener(_onVideoPlayerStatusChanged);
                          //
                          _videoPlayerController.dispose();
                          //
                          setVideoController(episode);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
