import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/models/episode.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:movie_web/widgets/film_detail/film_detail.dart';

class VideoPlayerChooseEpisode extends StatefulWidget {
  const VideoPlayerChooseEpisode({super.key});

  @override
  State<VideoPlayerChooseEpisode> createState() => _VideoPlayerChooseEpisodeState();
}

class _VideoPlayerChooseEpisodeState extends State<VideoPlayerChooseEpisode> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final seasons = filmData['seasons'];
    final currentSeasonIndex = filmData['currentSeasonIndex'];
    final List<Episode> episodes = seasons[currentSeasonIndex].episodes;

    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
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
              const Spacer(),
              PopupMenuButton(
                position: PopupMenuPosition.under,
                offset: const Offset(0, 4),
                color: const Color(0xFF333333),
                surfaceTintColor: Colors.transparent,
                itemBuilder: (ctx) => List.generate(
                  seasons.length,
                  (index) => PopupMenuItem(
                    onTap: () {
                      setState(() {
                        filmData['currentSeasonIndex'] = index;
                      });
                    },
                    child: Text(
                      seasons[index].name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                tooltip: '',
                child: Ink(
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 18,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 28,
                        color: Colors.white,
                      ),
                      const Gap(6),
                      Text(
                        seasons[filmData['currentSeasonIndex']].name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          SizedBox(
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
                              Navigator.of(context).pop(
                                {
                                  'episode': episodes[index],
                                },
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
          ),
        ],
      ),
    );
  }
}
