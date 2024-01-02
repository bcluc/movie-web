import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/models/poster.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:movie_web/widgets/grid/grid_films.dart';
import 'package:movie_web/widgets/skeleton_loading.dart';
import 'package:readmore/readmore.dart';

class PersonDetailDialog extends StatefulWidget {
  const PersonDetailDialog({
    super.key,
    required this.personId,
    required this.isCast,
  });

  final String personId;
  final bool isCast;

  @override
  State<PersonDetailDialog> createState() => _PersonDetailDialogState();
}

class _PersonDetailDialogState extends State<PersonDetailDialog> {
  late final Map<String, dynamic> _person;
  final List<Poster> _credits = [];
  late final _futurePerson = _fetchPersonInfo();

  Future<void> _fetchPersonInfo() async {
    _person = await supabase
        .from('person')
        .select('name, biography, known_for_department, birthday, gender, profile_path')
        .eq('id', widget.personId)
        .single();

    // _credits theo tmdb là những bộ phim có sự tham gia của người đó
    final List<dynamic> creditsData = await supabase
        .from(widget.isCast ? 'cast' : 'crew')
        .select('film(id, poster_path)')
        .eq('person_id', widget.personId);

    for (var element in creditsData) {
      _credits.add(
        Poster(filmId: element['film']['id'], posterPath: element['film']['poster_path']),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xFF111111),
      child: Ink(
        width: min(MediaQuery.sizeOf(context).width * 0.7, 900),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Thông tin ${widget.isCast ? 'Diễn viên' : 'Đội ngũ'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(30),
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
              ],
            ),
            const Gap(30),
            FutureBuilder(
              future: _futurePerson,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return buildSkeletonLoading();
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_tethering_error_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Truy xuất thông tin diễn viên thất bại',
                          style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }

                DateTime? birthday;
                if (_person['birthday'] != null) {
                  birthday = DateTime.parse(_person['birthday']);
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 240,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAlias,
                                child: _person['profile_path'] != null
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w440_and_h660_face/${_person['profile_path']}',
                                        width: 160,
                                      )
                                    : const SizedBox(
                                        width: 160,
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tên',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _person['name'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Ngày sinh',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        birthday == null
                                            ? '-'
                                            : '${vnDateFormat.format(birthday)} (${calculateAgeFrom(birthday)} tuổi)',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Giới tính',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _person['gender'] == 0 ? 'Nam' : 'Nữ',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Nghề nghiệp',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${_person['known_for_department']}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tiểu sử',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(8),
                        _person['biography'] == null
                            ? const Text(
                                '-',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            : ReadMoreText(
                                _person['biography'] + '   ',
                                trimLines: 10,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Xem thêm',
                                trimExpandedText: 'Ẩn bớt',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                moreStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                lessStyle: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                // textAlign: TextAlign.justify,
                              ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tuyển tập',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridFilms(
                          posters: _credits,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSkeletonLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 240,
            child: Row(
              children: [
                SkeletonLoading(
                  height: 240,
                  width: 160,
                ),
                SizedBox(
                  width: 24,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoading(height: 40, width: 100),
                    SkeletonLoading(height: 40, width: 150),
                    SkeletonLoading(height: 40, width: 80),
                    SkeletonLoading(height: 40, width: 110),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          SkeletonLoading(height: 26, width: 80),
          SizedBox(
            height: 4,
          ),
          SkeletonLoading(height: 210, width: double.infinity),
        ],
      ),
    );
  }

  int calculateAgeFrom(DateTime birthday) {
    final currentDate = DateTime.now();
    int age = DateTime.now().year - birthday.year;

    // Adjust the age if the birthdate hasn't occurred yet this year
    if (currentDate.month < birthday.month ||
        (currentDate.month == birthday.month && currentDate.day < birthday.day)) {
      age--;
    }

    return age;
  }
}
