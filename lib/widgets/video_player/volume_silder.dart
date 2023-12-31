import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_web/cubits/volume/volume_slider_cubit.dart';
import 'package:video_player/video_player.dart';

class VolumeSlider extends StatefulWidget {
  const VolumeSlider(
    this.videoPlayerController,
    this.startCountdownToDismissControls,
    this.cancelTimer, {
    super.key,
  });

  final VideoPlayerController videoPlayerController;
  final void Function() startCountdownToDismissControls;
  final void Function() cancelTimer;

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
          child: RotatedBox(
            quarterTurns: -1,
            child: BlocBuilder<VolumeSliderCubit, double>(
              builder: (ctx, volume) {
                return Slider(
                  value: volume,
                  onChangeStart: (_) => widget.cancelTimer(),
                  onChanged: (value) {
                    context.read<VolumeSliderCubit>().setVolume(value);
                    widget.videoPlayerController.setVolume(value);
                  },
                  onChangeEnd: (_) => widget.startCountdownToDismissControls(),
                );
              },
            ),
          ),
        ),
        const Icon(
          Icons.volume_up_rounded,
          color: Colors.white,
        ),
      ],
    );
  }
}
