import 'package:flutter_bloc/flutter_bloc.dart';

class MyListCubit extends Cubit<List<String>> {
  MyListCubit() : super([]);

  void setList(List<String> myList) => emit(myList);
  void addFilms(String filmId) => emit([...state, filmId]);
  void removeFilms(String filmId) => emit(
        state.where((element) => element != filmId).toList(),
      );

  bool contain(String filmId) => state.contains(filmId);
}
