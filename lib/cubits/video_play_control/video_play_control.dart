import 'package:flutter_bloc/flutter_bloc.dart';

enum VideoState {
  playing,
  pause,
}

class VideoPlayControlCubit extends Cubit<VideoState> {
  VideoPlayControlCubit() : super(VideoState.playing);

  void play() => emit(VideoState.playing);
  void pause() => emit(VideoState.pause);
}
