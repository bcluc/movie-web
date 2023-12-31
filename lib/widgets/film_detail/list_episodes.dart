import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/cubits/video_play_control/video_play_control.dart';
import 'package:movie_web/cubits/video_slider/video_slider_cubit.dart';
import 'package:movie_web/models/episode.dart';
import 'package:movie_web/models/season.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:movie_web/widgets/film_detail/film_detail.dart';
import 'package:movie_web/widgets/video_player/video_player_view.dart';

class ListEpisodes extends StatefulWidget {
  const ListEpisodes({super.key});

  @override
  State<ListEpisodes> createState() => _ListEpisodesState();
}

class _ListEpisodesState extends State<ListEpisodes> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final List<Season> seasons = filmData['seasons'];
    final currentSeasonIndex = filmData['currentSeasonIndex'];
    final List<Episode> episodes = seasons[currentSeasonIndex].episodes;

    return SizedBox(
      height: 360,
      child: RawScrollbar(
        controller: _scrollController,
        thumbColor: primaryColor(context),
        thickness: 7,
        radius: const Radius.circular(4),
        thumbVisibility: true,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: episodes.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return Ink(
              padding: const EdgeInsets.only(right: 14),
              width: 225,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFF333333),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          'https://www.themoviedb.org/t/p/w454_and_h254_bestv2/${episodes[index].stillPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 127,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (ctx) => VideoSliderCubit(),
                                ),
                                BlocProvider(
                                  create: (ctx) => VideoPlayControlCubit(),
                                ),
                              ],
                              child: VideoPlayerView(
                                firstEpisodeToPlay: episodes[index],
                              ),
                            ),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Center(
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Gap(6),
                  Text(
                    episodes[index].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Text(
                    episodes[index].subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 8,
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
