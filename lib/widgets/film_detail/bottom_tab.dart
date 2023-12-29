import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/episode.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/widgets/grid/grid_shimmer.dart';
import 'package:movie_web/widgets/film_detail/list_episodes.dart';
import 'package:movie_web/widgets/grid/grid_films.dart';
import 'package:movie_web/widgets/grid/grid_persons.dart';

import 'package:http/http.dart' as http;

class BottomTab extends StatefulWidget {
  const BottomTab({
    super.key,
    required this.filmId,
    required this.isMovie,
    required this.episode,
  });

  final String filmId;
  final bool isMovie;
  final List<Episode> episode;

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> with TickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;

  late final _listEpisodes = ListEpisodes(widget.episode);

  final _gridShimmer = const GridShimmer();

  final List<Poster> _recommendFilms = [];
  late final _futureRecommendFilms = _fetchRecommendFilms();

  late final List<dynamic> _castData;
  late final _futureCastData = _fetchCastData();

  late final List<dynamic> _crewData;
  late final _futureCrewData = _fetchCrewData();

  Future<void> _fetchRecommendFilms() async {
    String type = widget.isMovie ? 'movie' : 'tv';
    String url =
        "https://api.themoviedb.org/3/$type/${widget.filmId}/recommendations?api_key=$tmdbApiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse the response JSON
      // print('Response: ${response.body}');
      Map<String, dynamic> data = json.decode(response.body);

      List<dynamic> results = data['results'];

      for (var i = 0; i < results.length; ++i) {
        if (results[i]['poster_path'] == null) {
          continue;
        }
        _recommendFilms.add(
          Poster(
            filmId: results[i]['id'].toString(),
            posterPath: results[i]['poster_path'],
          ),
        );
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> _fetchCastData() async {
    _castData = await supabase
        .from('cast')
        .select('role: character, person(id, name, profile_path, popularity)')
        .eq('film_id', widget.filmId);

    _castData
        .sort((a, b) => b['person']['popularity'].compareTo(a['person']['popularity']));

    // String casts = '';
    // for (var element in _castData) {
    //   casts += element['person']['name'] + ', ';
    // }

    // print('casts = ' + casts);

    // String characters = '';
    // for (var element in _castData) {
    //   characters += element['role'] + ', ';
    // }

    // print('characters = $characters');
  }

  Future<void> _fetchCrewData() async {
    _crewData = await supabase
        .from('crew')
        .select('role: job, person(id, name, profile_path, popularity, gender)')
        .eq('film_id', widget.filmId);

    _crewData
        .sort((a, b) => b['person']['popularity'].compareTo(a['person']['popularity']));

    // String crews = '';
    // for (var element in _crewData) {
    //   crews += element['person']['name'] + ', ';
    // }

    // print('crews = ' + crews);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3 + (widget.isMovie ? 0 : 1),
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          labelColor: Colors.white,
          unselectedLabelStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelColor: Colors.white.withOpacity(0.6),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 4,
          splashBorderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.white.withOpacity(0.2);
            }
            if (states.contains(MaterialState.pressed)) {
              return Colors.white.withOpacity(0.2);
            }
            return Colors.transparent;
          }),
          tabs: [
            if (!widget.isMovie)
              const Tab(
                text: 'Tập phim',
              ),
            const Tab(
              text: 'Diễn viên',
            ),
            const Tab(
              text: 'Đội ngũ',
            ),
            const Tab(
              text: 'Đề xuất',
            ),
          ],
        ),
        const Gap(20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          child: switch (_tabIndex + (widget.isMovie ? 1 : 0)) {
            0 => _listEpisodes,
            1 => FutureBuilder(
                future: _futureCastData,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _gridShimmer;
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Truy xuất thông tin Diễn viên thất bại',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }

                  return GridPersons(personsData: _castData);
                },
              ),
            2 => FutureBuilder(
                future: _futureCrewData,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _gridShimmer;
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Truy xuất thông tin Đội ngũ thất bại',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }

                  return GridPersons(
                    personsData: _crewData,
                    isCast: false,
                  );
                },
              ),
            3 => FutureBuilder(
                future: _futureRecommendFilms,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _gridShimmer;
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      'Truy xuất thông tin Đề xuất thất bại',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    );
                  }

                  return GridFilms(
                    posters: _recommendFilms,
                    canClick: false,
                  );
                },
              ),
            _ => null,
          },
        ),
      ],
    );
  }
}
