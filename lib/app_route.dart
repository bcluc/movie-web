import 'package:go_router/go_router.dart';
import 'package:movie_web/screens/auth/sign_up.dart';
import 'package:movie_web/screens/auth/sign_in.dart';
import 'package:movie_web/screens/browse.dart';
import 'package:movie_web/screens/intro.dart';
import 'package:movie_web/screens/splash.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/intro',
      name: 'intro',
      builder: (ctx, state) => const IntroScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      builder: (ctx, state) => const SignInScreen(),
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign-up',
      builder: (ctx, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/browse',
      name: 'browse',
      builder: (ctx, state) => const BrowseScreen(),
    ),
  ],
);
