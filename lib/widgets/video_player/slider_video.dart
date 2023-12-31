import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_web/cubits/video_slider/video_slider_cubit.dart';
import 'package:video_player/video_player.dart';

String _convertFromDuration(Duration duration) {
  int mins = duration.inMinutes;
  int secs = duration.inSeconds % 60;

  return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}

String _convertFromSeconds(int initalSeconds) {
  int mins = (initalSeconds ~/ 60);
  int secs = (initalSeconds % 60);
  return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}

class SliderVideo extends StatelessWidget {
  const SliderVideo(
    this.overlayVisible,
    this.videoPlayerController,
    this.startCountdownToDismissControls,
    this.cancelTimer,
    this.removeProgressListener,
    this.addProgressListener, {
    super.key,
  });

  final bool overlayVisible;
  final VideoPlayerController videoPlayerController;
  final void Function() cancelTimer;
  final void Function() startCountdownToDismissControls;

  final void Function() removeProgressListener;
  final void Function() addProgressListener;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<VideoSliderCubit, double>(
        builder: (context, progressSlider) {
          // print('progressSlider = $progressSlider');
          return Row(
            children: [
              Expanded(
                child: Slider(
                  value: progressSlider,
                  label: _convertFromSeconds(
                    (progressSlider * videoPlayerController.value.duration.inSeconds).toInt(),
                  ),
                  onChanged: (value) {
                    context.read<VideoSliderCubit>().setProgress(value);
                  },
                  onChangeStart: (value) async {
                    await videoPlayerController.pause();
                    removeProgressListener();
                    cancelTimer();
                  },
                  onChangeEnd: (value) async {
                    await videoPlayerController.seekTo(
                      Duration(
                        milliseconds: (value * videoPlayerController.value.duration.inMilliseconds).toInt(),
                      ),
                    );
                    addProgressListener();
                    videoPlayerController.play();
                    startCountdownToDismissControls();
                  },
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  _convertFromDuration(videoPlayerController.value.duration - videoPlayerController.value.position),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
