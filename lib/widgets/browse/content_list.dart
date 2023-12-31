import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_web/cubits/app_bar/app_bar_cubit.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:movie_web/widgets/film_detail/film_detail.dart';
import 'package:page_transition/page_transition.dart';

class ContentList extends StatefulWidget {
  const ContentList({
    super.key,
    required this.title,
    required this.films,
    this.isOriginals = false,
  });

  final String title;
  final List<Poster> films;
  final bool isOriginals;

  @override
  State<ContentList> createState() => _ContentListState();
}

class _ContentListState extends State<ContentList> {
  bool _isHover = false;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 16, bottom: 6),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: widget.isOriginals ? 420 : 225,
          child: StatefulBuilder(builder: (ctx, setStateStack) {
            return MouseRegion(
              onEnter: (_) => setStateStack(() => _isHover = true),
              onExit: (_) => setStateStack(() => _isHover = false),
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      final film = widget.films[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: widget.isOriginals ? 280 : 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: TapRegion(
                          onTapInside: (_) {
                            Navigator.of(context).push(
                              PageTransition(
                                child: BlocProvider(
                                  create: (context) => AppBarCubit(),
                                  child: FilmDetail(filmId: film.filmId),
                                ),
                                type: PageTransitionType.rightToLeft,
                                duration: 300.ms,
                                reverseDuration: 300.ms,
                                settings:
                                    RouteSettings(name: '/film_detail@${film.filmId}'),
                              ),
                            );
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Image(
                              image: NetworkImage(
                                widget.isOriginals
                                    ? 'https://image.tmdb.org/t/p/w600_and_h900_bestv2/${film.posterPath}'
                                    : 'https://image.tmdb.org/t/p/w440_and_h660_face/${film.posterPath}',
                              ),
                              fit: BoxFit.cover,
                              // https://api.flutter.dev/flutter/widgets/Image/frameBuilder.html
                              frameBuilder: (
                                BuildContext context,
                                Widget child,
                                int? frame,
                                bool wasSynchronouslyLoaded,
                              ) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(
                                    milliseconds: 500,
                                  ), // Adjust the duration as needed
                                  curve: Curves.easeInOut,
                                  child: child, // Adjust the curve as needed
                                );
                              },
                              // https://api.flutter.dev/flutter/widgets/Image/loadingBuilder.html
                              loadingBuilder: (
                                BuildContext context,
                                Widget child,
                                ImageChunkEvent? loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: SizedBox(
                                    width: widget.isOriginals ? 48 : 36,
                                    height: widget.isOriginals ? 48 : 36,
                                    child: const CircularProgressIndicator(
                                      color: Colors.grey,
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: widget.films.length,
                  ),
                  if (_isHover)
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset - 400,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  if (_isHover)
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.offset + 400,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}
