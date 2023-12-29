import 'package:flutter/material.dart';
import 'package:movie_web/models/poster.dart';

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
                    // String? prior =
                    //     context.read<RouteStackCubit>().findPrior('/film_detail@$filmId');
                    // // print('prior = $prior');
                    // /*
                    // prior là route trước của /film_detail@$filmId
                    // nếu /film_detail@$filmId có trong RouteStack
                    // */

                    // if (prior != null) {
                    //   // Trong Stack đã từng di chuyển tới Phim này rồi
                    //   Navigator.of(context).pushAndRemoveUntil(
                    //     PageTransition(
                    //       child: FilmDetail(
                    //         filmId: filmId,
                    //       ),
                    //       type: PageTransitionType.rightToLeft,
                    //       duration: 300.ms,
                    //       reverseDuration: 300.ms,
                    //       settings: RouteSettings(name: '/film_detail@$filmId'),
                    //     ),
                    //     (route) {
                    //       // print(route.settings.name);
                    //       if (route.settings.name == prior) {
                    //         /*
                    //         Khi đã gặp prior route của /film_detail@$filmId
                    //         Thì push /film_detail@$filmId vào Stack
                    //         */
                    //         context.read<RouteStackCubit>().push('/film_detail@$filmId');
                    //         context.read<RouteStackCubit>().printRouteStack();
                    //         return true;
                    //       } else {
                    //         context.read<RouteStackCubit>().pop();
                    //         return false;
                    //       }
                    //     },
                    //   );
                    // } else {
                    //   // Chưa từng di chuyển tới Phim này
                    //   context.read<RouteStackCubit>().push('/film_detail@$filmId');
                    //   context.read<RouteStackCubit>().printRouteStack();
                    //   Navigator.of(context).push(
                    //     PageTransition(
                    //       child: FilmDetail(
                    //         filmId: filmId,
                    //       ),
                    //       type: PageTransitionType.rightToLeft,
                    //       duration: 300.ms,
                    //       reverseDuration: 300.ms,
                    //       settings: RouteSettings(name: '/film_detail@$filmId'),
                    //     ),
                    //   );
                    // }
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
