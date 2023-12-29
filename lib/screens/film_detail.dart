import 'dart:ui' as dart_ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/episode.dart';
import 'package:movie_web/models/film.dart';
import 'package:movie_web/models/genre.dart';
import 'package:movie_web/models/review_film.dart';
import 'package:movie_web/models/season.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:movie_web/utils/extension.dart';
import 'package:movie_web/widgets/film_detail/bottom_tab.dart';

class FilmDetail extends StatefulWidget {
  const FilmDetail({
    super.key,
    required this.filmId,
  });

  final String filmId;

  @override
  State<FilmDetail> createState() => _FilmDetailState();
}

class _FilmDetailState extends State<FilmDetail> {
  late final Film _film;

  late final bool _isMovie;
  bool _isExpandOverview = false;

  int _currentSeasonIndex = 0;

  late final _futureMovie = _fetchMovie();
  Future<void> _fetchMovie() async {
    final filmInfo = await supabase
        .from('film')
        .select(
          'name, release_date, vote_average, vote_count, overview, backdrop_path, poster_path, content_rating, trailer',
        )
        .eq('id', widget.filmId)
        .single();

    // print('filmData = $filmInfo');

    _film = Film(
      id: widget.filmId,
      name: filmInfo['name'],
      releaseDate: DateTime.parse(filmInfo['release_date']),
      voteAverage: filmInfo['vote_average'],
      voteCount: filmInfo['vote_count'],
      overview: filmInfo['overview'],
      backdropPath: filmInfo['backdrop_path'],
      posterPath: filmInfo['poster_path'],
      contentRating: filmInfo['content_rating'],
      trailer: filmInfo['trailer'],
      genres: [],
      seasons: [],
      reviews: [],
    );
    // print('backdrop_path = ${_film!['backdrop_path']}');
    final List<dynamic> genresData =
        await supabase.from('film_genre').select('genre(*)').eq('film_id', widget.filmId);

    for (var genreRow in genresData) {
      _film.genres.add(
        Genre(
          genreId: genreRow['genre']['id'],
          name: genreRow['genre']['name'],
        ),
      );
    }

    // print(_film.genres.length);

    final List<dynamic> seasonsData = await supabase
        .from('season')
        .select('id, name, episode(*)')
        .eq('film_id', widget.filmId)
        .order('id', ascending: true)
        .order('order', referencedTable: 'episode', ascending: true);

    for (var seasonRow in seasonsData) {
      final season = Season(
        seasonId: seasonRow['id'],
        name: seasonRow['name'],
        episodes: [],
      );

      final List<dynamic> episodesData = seasonRow['episode'];
      // print(episodesData);

      for (final episodeRow in episodesData) {
        season.episodes.add(
          Episode(
            episodeId: episodeRow['id'],
            order: episodeRow['order'],
            stillPath: episodeRow['still_path'],
            title: episodeRow['title'],
            runtime: episodeRow['runtime'],
            subtitle: episodeRow['subtitle'],
            linkEpisode: episodeRow['link'],
          ),
        );
      }

      _film.seasons.add(season);
    }
    // print(_film.seasons.length);

    final List<dynamic> reviewsData = await supabase
        .from('review')
        .select('user_id, star, created_at, profile(full_name, avatar_url)')
        .eq('film_id', widget.filmId);

    // print(reviewsData);

    for (var element in reviewsData) {
      _film.reviews.add(
        ReviewFilm(
          userId: element['user_id'],
          hoTen: element['profile']['full_name'],
          avatarUrl: element['profile']['avatar_url'],
          star: element['star'],
          createAt: vnDateFormat.parse(element['created_at']),
        ),
      );
    }

    _film.reviews.sort((a, b) => b.createAt.compareTo(a.createAt));

    _isMovie = _film.seasons[0].name == '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Đã test - Không sửa
      onWillPop: () async {
        // context.read<RouteStackCubit>().pop();
        // context.read<RouteStackCubit>().printRouteStack();
        return true;
      },
      child: Scaffold(
        body: FutureBuilder(
          future: _futureMovie,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Có lỗi xảy ra khi truy vấn thông tin phim',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            double voteAverage = 0;
            if (_film.reviews.isNotEmpty) {
              voteAverage = _film.reviews
                      .fold(0, (previousValue, review) => previousValue + review.star) /
                  _film.reviews.length;

              // print(voteAverage);
            }

            final textPainter = TextPainter(
              text: TextSpan(
                text: _film.overview,
                style: const TextStyle(color: Colors.white),
              ),
              maxLines: 4,
              textDirection: dart_ui.TextDirection.ltr,
            )..layout(minWidth: 0, maxWidth: MediaQuery.sizeOf(context).width);
            final isOverflowed = textPainter.didExceedMaxLines;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Ink(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                'https://image.tmdb.org/t/p/original/${_film.backdropPath}',
                              ),
                              fit: BoxFit.cover),
                        ),
                        width: double.infinity,
                        height: 9 / 16 * MediaQuery.sizeOf(context).width,
                      ),
                      // Layer Gradient 1
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      // Layer Gradient 2
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.transparent,
                              ],
                              stops: [0, 0.5],
                              begin: Alignment.bottomLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      /* Back Button */
                      Positioned(
                        top: 50,
                        left: 50,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding:
                                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(2.0, 4.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              Gap(10),
                              Text(
                                'Trở lại',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      offset: Offset(2.0, 4.0),
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /* Content Rating */
                      Positioned(
                        bottom: 360,
                        right: 0,
                        width: 90,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF696A6A).withOpacity(0.7),
                            border: const Border(
                              left: BorderSide(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Text(
                            _film.contentRating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      /* Film's Info */
                      Positioned(
                        bottom: 20,
                        left: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _film.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(2.0, 4.0),
                                    blurRadius: 6.0,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            /* Nếu Film được chọn là movie, thì nó không có Season */
                            if (!_isMovie) ...[
                              const Gap(24),
                              StatefulBuilder(
                                builder: (ctx, setStateSeasonButton) {
                                  return PopupMenuButton(
                                    position: PopupMenuPosition.under,
                                    offset: const Offset(0, 2),
                                    color: Color(0xFF333333),
                                    surfaceTintColor: Colors.transparent,
                                    itemBuilder: (ctx) => List.generate(
                                      _film.seasons.length,
                                      (index) => PopupMenuItem(
                                        onTap: () {
                                          setStateSeasonButton(() {
                                            _currentSeasonIndex = index;
                                          });
                                        },
                                        child: Text(
                                          _film.seasons[index].name,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    tooltip: '',
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF333333),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 24,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            _film.seasons[_currentSeasonIndex].name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Gap(10),
                                          const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            const Gap(24),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Điểm:   ${voteAverage == 0 ? 'Chưa có đánh giá' : 'Điểm: ${(voteAverage * 2).toStringAsFixed(2)}'}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Gap(40),
                                Ink(
                                  height: 28,
                                  width: 2,
                                  color: Colors.white,
                                ),
                                const Gap(40),
                                Text(
                                  'Phát hành:   ${_film.releaseDate.toVnFormat()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(24),
                            const Text(
                              'Thể loại: ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                _film.genres.length,
                                (index) {
                                  bool isHover = false;
                                  return StatefulBuilder(
                                    builder: (ctx, setStateGenre) {
                                      return TapRegion(
                                        onTapInside: (event) {},
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          onEnter: (_) =>
                                              setStateGenre(() => isHover = true),
                                          onExit: (_) =>
                                              setStateGenre(() => isHover = false),
                                          child: Text(
                                            _film.genres[index].name +
                                                (index == _film.genres.length - 1
                                                    ? ''
                                                    : ', '),
                                            style: TextStyle(
                                              color: const Color(0xFFBEBEBE),
                                              decoration: isHover
                                                  ? TextDecoration.underline
                                                  : null,
                                              decorationColor: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _film.overview,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: _isExpandOverview ? 100 : 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                        ),
                        const Gap(4),
                        if (isOverflowed)
                          InkWell(
                            onTap: () => setState(() {
                              _isExpandOverview = !_isExpandOverview;
                            }),
                            child: Text(
                              _isExpandOverview ? 'Ẩn bớt' : 'Xem thêm',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        const Gap(4),
                        BottomTab(
                          filmId: _film.id,
                          isMovie: _isMovie,
                          episode: _film.seasons[_currentSeasonIndex].episodes,
                        ),
                        const Gap(20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
