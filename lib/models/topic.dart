import 'package:movie_web/models/poster.dart';

class Topic {
  String name;
  List<Poster> posters;

  Topic({
    required this.name,
    required this.posters,
  });
}
