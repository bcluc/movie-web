import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/cubits/app_bar/app_bar_cubit.dart';
import 'package:movie_web/cubits/my_list/my_list_cubit.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:movie_web/widgets/grid/grid_films.dart';
import 'package:shimmer/shimmer.dart';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  late final Size _screenSize = MediaQuery.sizeOf(context);

  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      context.read<AppBarCubit>().setOffset(_scrollController.offset);
    });

  final List<Poster> _postersData = [];

  Future<void> _fetchMyListFilms() async {
    _postersData.clear();

    final filmIds = context.watch<MyListCubit>().state;

    for (final filmId in filmIds) {
      final Map<String, dynamic> posterData = await supabase.from('film').select('poster_path').eq('id', filmId).single();

      _postersData.add(
        Poster(
          filmId: filmId,
          posterPath: posterData['poster_path'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(_screenSize.width, 100),
        child: BlocBuilder<AppBarCubit, double>(
          builder: (ctx, offset) {
            return CustomAppBar(
              scrollOffset: offset,
            );
          },
        ),
      ),
      body: FutureBuilder(
        future: _fetchMyListFilms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                context.watch<MyListCubit>().state.length,
                (index) => Shimmer.fromColors(
                  baseColor: Colors.white.withAlpha(100),
                  highlightColor: Colors.grey,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ColoredBox(
                      color: Colors.white.withAlpha(100),
                    ),
                  ),
                ),
              ),
            );
          }

          // Wrap GridFilms trong SizedBox.expand() vì
          // GridFilms được thiết lập để dài ra theo những con trong nó thôi (shrinkWrap: true,)
          // Nên hiệu ứng slideY bắt đầu từ 0.3 sẽ không được đồng đều
          // Thể thoại này có ít phim thể loại kia có nhiều phim nên height của GridFilms là khác nhau
          return _postersData.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.image_search,
                        color: Colors.grey,
                        size: 64,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: Text(
                          'Bạn chưa thêm thêm phim nào vào Danh sách',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.expand(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Danh sách của tôi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(30),
                          GridFilms(
                            posters: _postersData,
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fadeIn(
                    begin: 0.5,
                    curve: Curves.easeInOut,
                  );
        },
      ),
    );
  }
}
