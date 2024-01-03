import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_web/cubits/app_bar/app_bar_cubit.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/widgets/film_detail/film_detail.dart';
import 'package:page_transition/page_transition.dart';

class GridFilms extends StatelessWidget {
  const GridFilms({
    super.key,
    required this.posters,
    this.canClick = true,
  });

  final List<Poster> posters;
  final bool canClick;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 225,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: List.generate(
        posters.length,
        (index) {
          final filmId = posters[index].filmId;
          return GestureDetector(
            onTap: canClick
                ? () {
                    Navigator.of(context).push(
                      PageTransition(
                        child: BlocProvider(
                          create: (context) => AppBarCubit(),
                          child: FilmDetail(
                            filmId: filmId,
                          ),
                        ),
                        type: PageTransitionType.rightToLeft,
                        duration: 300.ms,
                        reverseDuration: 300.ms,
                        settings: RouteSettings(name: '/film_detail@$filmId'),
                      ),
                    );
                  }
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://image.tmdb.org/t/p/w440_and_h660_face/${posters[index].posterPath}',
              ),
            ),
          );
        },
      ),
    );
  }
}
