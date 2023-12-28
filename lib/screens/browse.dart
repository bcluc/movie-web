import 'package:flutter/material.dart';
import 'package:movie_web/data/dynamic/topics_data.dart';
import 'package:movie_web/widgets/browe_header.dart';
import 'package:movie_web/widgets/content_list.dart';
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
      setState(() {});
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
              child: CustomAppBar(
                scrollOffset: _scrollController.hasClients ? _scrollController.offset : 0,
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
                      isOriginals: topic.name == 'Chỉ có trên Netflix',
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 20))
              ],
            ),
          )
        : ColoredBox(
            color: Colors.black,
          );
  }
}
