import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/widgets/grid/grid_films.dart';
import 'package:movie_web/widgets/grid/grid_shimmer.dart';

class FilmsByGenreDialog extends StatefulWidget {
  const FilmsByGenreDialog({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  final String genreId;
  final String genreName;

  @override
  State<FilmsByGenreDialog> createState() => _FilmsByGenreDialogState();
}

class _FilmsByGenreDialogState extends State<FilmsByGenreDialog> {
  final List<Poster> _posters = [];
  late final _futureFilms = _fetchFilmsOnDemand();

  Future<void> _fetchFilmsOnDemand() async {
    final List<dynamic> postersData = await supabase.from('film_genre').select('film(id, poster_path)').eq('genre_id', widget.genreId);

    for (var element in postersData) {
      _posters.add(
        Poster(
          filmId: element['film']['id'],
          posterPath: element['film']['poster_path'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xFF111111),
      child: Ink(
        width: min(MediaQuery.sizeOf(context).width * 0.7, 900),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Thể loại: ${widget.genreName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(30),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 32,
                  ),
                ),
              ],
            ),
            const Gap(30),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: _futureFilms,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const GridShimmer();
                    }

                    // Wrap GridFilms trong SizedBox.expand() vì
                    // GridFilms được thiết lập để dài ra theo những con trong nó thôi (shrinkWrap: true,)
                    // Nên hiệu ứng slideY bắt đầu từ 0.3 sẽ không được đồng đều
                    // Thể thoại này có ít phim thể loại kia có nhiều phim nên height của GridFilms là khác nhau
                    return GridFilms(
                      posters: _posters,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
