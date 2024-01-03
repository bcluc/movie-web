import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/data/dynamic/profile_data.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/review_film.dart';
import 'package:movie_web/utils/extension.dart';
import 'package:movie_web/widgets/film_detail/film_detail.dart';

class FilmReviews extends StatefulWidget {
  const FilmReviews({
    super.key,
    required this.onReviewHasChanged,
  });

  final void Function() onReviewHasChanged;

  @override
  State<FilmReviews> createState() => _FilmReviewsState();
}

class _FilmReviewsState extends State<FilmReviews> {
  /* _existing_rateIndex: cho biết người dùng hiện tại đã đánh giá, cho điểm bộ phim hay chưa */
  int _existingRateIndex = -1;
  int _rate = 5;

  bool _isProcessing = false;

  Future<void> pushReview() async {
    setState(() {
      _isProcessing = true;
    });

    await supabase.from('review').upsert(
      {
        'user_id': supabase.auth.currentUser!.id,
        'star': _rate,
        'created_at': DateTime.now().toVnFormat(),
        'film_id': filmData['filmId'],
      },
    );

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Cảm ơn bạn đã đánh giá phim',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          width: 400,
        ),
      );
    }

    if (_existingRateIndex != -1) {
      /*
      Người này đã rate phim này trước đó rồi
      => Xoá rate cũ trước thêm rate mới vào
      */
      filmData['reviews'].removeAt(_existingRateIndex);
    }

    filmData['reviews'].insert(
      0,
      ReviewFilm(
        userId: supabase.auth.currentUser!.id,
        hoTen: profileData['full_name'],
        avatarUrl: profileData['avatar_url'],
        star: _rate,
        createAt: DateTime.now(),
      ),
    );

    _existingRateIndex = 0;

    /*
    Thông báo cho Widget cha để cập nhật lại điểm số với đánh giá mới
    */
    widget.onReviewHasChanged();

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  void initState() {
    super.initState();

    /* 
    Check xem người dùng đã bình chọn cho phim này chưa 
    Nếu rồi thì _existingRateIndex != 1
    */
    for (var i = 0; i < filmData['reviews'].length; ++i) {
      // print('${element.hoTen} ${element.star}');
      final review = filmData['reviews'][i];
      if (review.userId == supabase.auth.currentUser!.id) {
        _existingRateIndex = i;
        _rate = review.star;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<ReviewFilm> reviews = filmData['reviews'];

    double voteAverage = 0;
    if (reviews.isNotEmpty) {
      voteAverage =
          reviews.fold(0, (previousValue, review) => previousValue + review.star) /
              reviews.length;

      // print(voteAverage);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.insert_chart_outlined_outlined,
              size: 40,
              color: Colors.white,
            ),
            const Gap(8),
            Text(
              '${reviews.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            const Text(
              'Lượt bình chọn',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const Gap(30),
        const Text(
          'Điểm đáng giá',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (voteAverage > 0) ...[
              Text(
                voteAverage.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(12),
              const Text(
                'trên 5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
              const Text(
                'Chưa có',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const Spacer(),
            SizedBox(
              width: 450,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: CachedNetworkImage(
                        imageUrl: '$baseAvatarUrl${profileData['avatar_url']}',
                        fit: BoxFit.cover,
                        // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                        fadeInDuration: const Duration(milliseconds: 400),
                        // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                        fadeOutDuration: const Duration(milliseconds: 800),
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeCap: StrokeCap.round,
                            strokeWidth: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileData['full_name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        buildStarRate(),
                      ],
                    ),
                  ),
                  const Gap(14),
                  IconButton.filled(
                    onPressed: _isProcessing ? null : pushReview,
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                    ),
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeCap: StrokeCap.round,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.arrow_upward_rounded),
                  ),
                  const Gap(12),
                ],
              ),
            )
          ],
        ),
        const Gap(20),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            childAspectRatio: 5 / 3.8,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: List.generate(
            reviews.length,
            (index) => buildReviewItem(index),
          ),
        ),
      ],
    );
  }

  Widget buildStarRate() {
    return StatefulBuilder(
      builder: (ctx, setStateRate) {
        return Row(
          children: List.generate(
            5,
            (index) => InkWell(
              onTap: () {
                setStateRate(() => _rate = index + 1);
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  index + 1 <= _rate ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildReviewItem(int index) {
    final ReviewFilm review = filmData['reviews'][index];
    return Ink(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 60,
              height: 60,
              child: CachedNetworkImage(
                imageUrl: '$baseAvatarUrl${review.avatarUrl}',
                fit: BoxFit.cover,
                // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                fadeInDuration: const Duration(milliseconds: 400),
                // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                fadeOutDuration: const Duration(milliseconds: 800),
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          ),
          const Gap(12),
          Text(
            review.hoTen,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(2),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              review.star,
              (index) => Icon(
                Icons.star_rounded,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
