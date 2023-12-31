import 'package:flutter_bloc/flutter_bloc.dart';

class VolumeSliderCubit extends Cubit<double> {
  VolumeSliderCubit() : super(1);

  void setVolume(double newVolume) => emit(newVolume);

  /* 
  0 <= volume <= 1,
  Mục để của Cubit này là,
  Khi người dùng xem tập phim A và thiết lập âm lượng phù hợp cho mình,
  thì khi chuyển sang tập phim khác vẫn giữ nguyên mức âm lượng đó
  */
}
