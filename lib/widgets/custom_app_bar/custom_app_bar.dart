import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/screens/search_film.dart';
import 'package:movie_web/widgets/dialog/new_hot.dart';
import 'package:movie_web/widgets/custom_app_bar/my_profile.dart';
import 'package:page_transition/page_transition.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.scrollOffset,
  });

  final double scrollOffset;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(
        (scrollOffset / 350).clamp(0, 1).toDouble(),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SafeArea(
        child: Row(
          children: [
            const Gap(40),
            /*
            Bởi vì preferredSize: Size(_screenSize.width, 90),
            Nên các con trong nó chỉ có thể cao tối đa 70
            */
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Image.asset(
                Assets.viovidLogo,
              ),
            ),
            const Gap(40),
            Expanded(
              child: Row(
                children: [
                  buildAppBarButton(
                    'Trang chủ',
                    scrollOffset,
                    () {
                      context.go('/browse');
                    },
                  ),
                  const Gap(20),
                  buildAppBarButton(
                    'Danh sách của tôi',
                    scrollOffset,
                    () {
                      context.go('/browse/my-list');
                    },
                  ),
                  const Gap(20),
                  buildAppBarButton(
                    'Mới phát hành',
                    scrollOffset,
                    () {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return const NewHotDialog();
                        },
                      );
                    },
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // context.read<RouteStackCubit>().push('/search_film_screen');
                      // context.read<RouteStackCubit>().printRouteStack();
                      Navigator.of(context).push(
                        PageTransition(
                          child: const SearchFilmScreen(),
                          type: PageTransitionType.fade,
                          duration: 300.ms,
                          reverseDuration: 300.ms,
                          settings: const RouteSettings(name: '/search_film_screen'),
                        ),
                      );
                    },
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(
                      Icons.search_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Notification
                    },
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(
                      Icons.notifications_active_rounded,
                    ),
                  ),
                  const Gap(20),
                  const MyProfile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAppBarButton(
    String text,
    double scrollOffset,
    void Function() onTap,
  ) {
    return SizedBox(
      height: 40,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(foregroundColor: Colors.white),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
