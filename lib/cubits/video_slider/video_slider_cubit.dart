import 'package:flutter_bloc/flutter_bloc.dart';

class VideoSliderCubit extends Cubit<double> {
  VideoSliderCubit() : super(0);

  void setProgress(double newProgress) => emit(newProgress);
}
