import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_web/cubits/app_bar/app_bar_cubit.dart';
import 'package:movie_web/cubits/my_list/my_list_cubit.dart';
import 'package:movie_web/data/dynamic/profile_data.dart';
import 'package:movie_web/data/dynamic/topics_data.dart';
import 'package:movie_web/widgets/browse/browe_header.dart';
import 'package:movie_web/widgets/browse/content_list.dart';
import 'package:movie_web/widgets/custom_app_bar/custom_app_bar.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  late final Size _screenSize = MediaQuery.sizeOf(context);

  late final ScrollController _scrollController = ScrollController()
    ..addListener(() {
      context.read<AppBarCubit>().setOffset(_scrollController.offset);
    });

  bool isFetchedData = false;

  @override
  void initState() {
    super.initState();
    /*
    Có thể người dùng sẽ 
    thay vì nhập viovid.com, họ lại nhập viovid.com/browse
    Nó sẽ vào thẳng Browse,
    Lúc này cần check xem người dùng đã đăng nhập hay chưa
    */
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchTopicsData();
      await fetchProfileData();
      // ignore: use_build_context_synchronously
      context.read<MyListCubit>().setList(profileData['my_list']);

      setState(() {
        isFetchedData = true;
      });
    });
    /* Executes a function only one time after the layout is completed*/
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isFetchedData
        ? Scaffold(
            extendBodyBehindAppBar: true,
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
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                const SliverToBoxAdapter(
                  child: BrowseHeader(),
                ),
                ...topicsData.map(
                  (topic) => SliverToBoxAdapter(
                    child: ContentList(
                      key: PageStorageKey(topic),
                      title: topic.name,
                      films: topic.posters,
                      isOriginals: topic.name == 'Chỉ có trên VioVid',
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 20))
              ],
            ),
          )
        : const ColoredBox(
            color: Colors.black,
          );
  }
}
