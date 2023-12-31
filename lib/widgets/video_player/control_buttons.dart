import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_web/cubits/video_play_control/video_play_control.dart';
import 'package:video_player/video_player.dart';

class ControlButtons extends StatefulWidget {
  const ControlButtons(
    this.videoPlayerController,
    this.startCountdownToDismissControls,
    this.cancelTimer, {
    super.key,
  });

  final VideoPlayerController videoPlayerController;
  final void Function() startCountdownToDismissControls;
  final void Function() cancelTimer;

  @override
  State<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends State<ControlButtons> {
  double replayTurns = 0;
  double forwardTurns = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimatedRotation(
            turns: replayTurns,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () {
                setState(() {
                  replayTurns -= 1;
                });
                widget.videoPlayerController.seekTo(widget.videoPlayerController.value.position - const Duration(seconds: 10));

                widget.cancelTimer();
                widget.startCountdownToDismissControls();
              },
              icon: const Icon(
                Icons.replay_10_rounded,
                size: 120,
              ),
              style: IconButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
          BlocBuilder<VideoPlayControlCubit, VideoState>(
            builder: (context, videoState) {
              return IconButton(
                onPressed: () {
                  videoState == VideoState.playing ? widget.videoPlayerController.pause() : widget.videoPlayerController.play();
                  widget.cancelTimer();
                  widget.startCountdownToDismissControls();
                },
                icon: Icon(
                  videoState == VideoState.playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 120,
                ),
                style: IconButton.styleFrom(foregroundColor: Colors.white),
              );
            },
          ),
          AnimatedRotation(
            turns: forwardTurns,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () {
                setState(() {
                  forwardTurns += 1;
                });
                widget.videoPlayerController.seekTo(
                  widget.videoPlayerController.value.position + const Duration(seconds: 10),
                );
                widget.cancelTimer();
                widget.startCountdownToDismissControls();
              },
              icon: const Icon(
                Icons.forward_10_rounded,
                size: 120,
              ),
              style: IconButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
