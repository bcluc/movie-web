import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/widgets/grid/grid_films.dart';

class SearchFilmScreen extends StatefulWidget {
  const SearchFilmScreen({super.key});

  @override
  State<SearchFilmScreen> createState() => _SearchFilmScreenState();
}

class _SearchFilmScreenState extends State<SearchFilmScreen> {
  final _searchController = TextEditingController();
  Timer _timer = Timer(const Duration(microseconds: 0), () {});
  final List<Poster> _searchResults = [];

  String _searchBarStatus = "empty";
  /*
  empty: Thanh tìm kiếm đang rỗng
  hasText: Thanh tìm kiếm đã được nhập vài ký tự
  */

  String _resultStatus = "none";
  /*
  none: chưa khởi động tìm kiếm
  processing: đang tìm
  hasResult: đã tìm kiếm xong
  */

  void search({required String keyword}) async {
    if (_searchController.text == keyword) {
      if (keyword.isEmpty) {
        return;
      }

      keyword.trim();
      // print("search operation: " + keyword);
      setState(() {
        _resultStatus = "processing";
      });

      /*
      Ở trên ta có câu lệnh setState(),
      Nếu không có lệnh await Future.delayed() bên dưới thì 
      khi hàm build được gọi _searchResults đã được clear() xong

      Vì vậy delay một khoảng để khi hàm build được gọi 
      _searchResults vẫn còn giá trị cũ chưa bị clear
      */
      await Future.delayed(const Duration(milliseconds: 300));
      _searchResults.clear();

      final List<dynamic> searchResult = await supabase
          .from('film')
          .select('id, poster_path')
          .ilike('search_context', '%$keyword%');

      for (var element in searchResult) {
        _searchResults.add(
          Poster(
            filmId: element['id'],
            posterPath: element['poster_path'],
          ),
        );
      }

      setState(() {
        _resultStatus = "hasResult";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // context.read<RouteStackCubit>().pop();
        // context.read<RouteStackCubit>().printRouteStack();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 32,
                    ),
                  ),
                  const Text(
                    'Tìm kiếm Phim',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(56),
                ],
              ),
              const Gap(20),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2B2B2B),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                    ),
                  ),
                  prefixIconColor: Colors.white.withOpacity(0.5),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: _resultStatus == "processing"
                        ? const SizedBox(
                            width: 48,
                            height: 48,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: _searchBarStatus == "empty"
                                ? () {}
                                : () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchResults.clear();
                                      _searchBarStatus = "empty";
                                      _resultStatus = "none";
                                    });
                                  },
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                            ),
                            icon: Icon(
                              _searchBarStatus == "empty"
                                  ? Icons.mic_rounded
                                  : Icons.close_rounded,
                            ),
                          ),
                  ),
                  suffixIconColor: Colors.white.withOpacity(0.5),
                  hintText: 'Nhập tên phim',
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 120, 120, 120),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                autocorrect: false,
                onChanged: (value) async {
                  // Khi người dùng từng ký tự => Kích hoạt lại bộ đếm
                  if (_timer.isActive) {
                    _timer.cancel();
                  }
                  // Khi người dùng từng ký tự => Đánh dấu là chưa kích hoạt tìm kiếm
                  _resultStatus = "none";

                  /*
                  Khi người dùng xoá hết tự khoá tìm kiếm
                  => Delay 1 khoảng 50ms để tạo độ mượt mà 
                  => Clear kết quả tìm kiếm trước đó
                  => Thiết lập Trạng thái của thanh tìm kiếm là rỗng (chưa nhập bất kỳ ký tự nào)
                  */
                  if (value.isEmpty) {
                    await Future.delayed(
                      const Duration(milliseconds: 50),
                    );
                    setState(() {
                      _searchResults.clear();
                      _searchBarStatus = "empty";
                    });
                  } else {
                    /*
                    Khi người dùng nhập từ khoá tìm kiếm
                    => Thiết lập Trạng thái của thanh tìm kiếm là hasText
                    => Tạo bộ điếm ngược, có tác dụng sau 1s sẽ kích hoạt tìm kiếm với từ khoá được nhập
                    */
                    if (_searchBarStatus != "hasText") {
                      setState(() {
                        _searchBarStatus = "hasText";
                      });
                    }
                    _timer = Timer(const Duration(seconds: 1), () {
                      search(keyword: value);
                    });
                  }
                },
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
              ),
              const Gap(10),
              Expanded(
                child: buildSearchResult(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchResult() {
    // print(_searchBarStatus);
    if (_searchBarStatus == "empty" || _resultStatus == "none") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/decor_image.png',
            width: max(MediaQuery.sizeOf(context).height * 0.3, 200),
          ),
          const Gap(16),
          Text(
            'Tìm bộ phim yêu thích của bạn',
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16,
            ),
          ),
          const Gap(40),
        ],
      );
    }
    if (_resultStatus == "hasResult" && _searchResults.isEmpty) {
      return Center(
        child: SizedBox(
          width: 240,
          child: Text(
            'Không tìm thấy phim khớp với từ khoá trên',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: GridFilms(posters: _searchResults),
    );
  }
}
