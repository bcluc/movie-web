import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/models/episode.dart';
import 'package:movie_web/utils/common_variables.dart';

class ListEpisodes extends StatefulWidget {
  const ListEpisodes(this.episodes, {super.key});

  final List<Episode> episodes;

  @override
  State<ListEpisodes> createState() => _ListEpisodesState();
}

class _ListEpisodesState extends State<ListEpisodes> {
  int selectedSeason = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
          itemCount: widget.episodes.length,
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
                          'https://www.themoviedb.org/t/p/w454_and_h254_bestv2/${widget.episodes[index].stillPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 127,
                    child: InkWell(
                      onTap: () {
                        // Navigator.of(context).pop(
                        //   {
                        //     'episode': widget.episode,
                        //     // seasonIndex là số thứ tự season chứa tập phim này
                        //     'season_index': widget.seasonIndex,
                        //   },
                        // );
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
                    widget.episodes[index].title,
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
                    widget.episodes[index].subtitle,
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
