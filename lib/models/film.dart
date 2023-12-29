import 'package:movie_web/models/genre.dart';
import 'package:movie_web/models/review_film.dart';
import 'package:movie_web/models/season.dart';

class Film {
  final String id;
  final String name;
  final DateTime releaseDate;
  final double voteAverage;
  final int voteCount;
  final String overview;
  final String backdropPath;
  final String posterPath;
  final String contentRating;
  final String trailer;
  final List<Genre> genres;
  final List<Season> seasons;
  final List<ReviewFilm> reviews;

  const Film({
    required this.id,
    required this.name,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.overview,
    required this.backdropPath,
    required this.posterPath,
    required this.contentRating,
    required this.trailer,
    required this.genres,
    required this.seasons,
    required this.reviews,
  });
}
