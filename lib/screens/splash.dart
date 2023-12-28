import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/screens/browse.dart';
import 'package:movie_web/screens/intro.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    final session = supabase.auth.currentSession;
    if (session != null) {
      // await fetchTopicsData();
      // await fetchProfileData();

      // context.read<MyListCubit>().setList(profileData['my_list']);
      // Navigator.of(context).pushReplacement(
      //   PageTransition(
      //     child: const BrowseScreen(),
      //     type: PageTransitionType.fade,
      //     duration: 800.ms,
      //     settings: const RouteSettings(name: '/browse'),
      //   ),
      // );
      context.go('/browse');
    } else {
      // Navigator.of(context).pushReplacement(
      //   PageTransition(
      //     child: const IntroScreen(),
      //     type: PageTransitionType.fade,
      //     duration: 800.ms,
      //     settings: const RouteSettings(name: '/intro'),
      //   ),
      // );
      context.go('/intro');
    }
  }

  @override
  void initState() {
    super.initState();
    // Executes a function only one time after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.primary,
        highlightColor: Colors.amber,
        child: Image.asset(
          Assets.viovidLogo,
          width: 240,
        ),
      ),
    );
  }
}
