import 'package:go_router/go_router.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/screens/auth/request_recovery.dart';
import 'package:movie_web/screens/auth/reset_password.dart';
import 'package:movie_web/screens/auth/sign_up.dart';
import 'package:movie_web/screens/auth/sign_in.dart';
import 'package:movie_web/screens/browse.dart';
import 'package:movie_web/screens/intro.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      redirect: (context, state) {
        if (supabase.auth.currentSession != null) {
          return '/browse';
        }
        return '/intro';
      },
    ),
    GoRoute(
      path: '/intro',
      name: 'intro',
      builder: (ctx, state) => const IntroScreen(),
      redirect: (context, state) {
        if (supabase.auth.currentSession != null) {
          return '/browse';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      builder: (ctx, state) => const SignInScreen(),
      redirect: (context, state) {
        if (supabase.auth.currentSession != null) {
          return '/browse';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/sign-up',
      name: 'sign-up',
      builder: (ctx, state) => const SignUpScreen(),
      redirect: (context, state) {
        if (supabase.auth.currentSession != null) {
          return '/browse';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/request-recovery',
      name: 'request-recovery',
      builder: (ctx, state) => const RequestRecovery(),
      redirect: (context, state) {
        if (supabase.auth.currentSession != null) {
          return '/browse';
        }
        return null;
      },
    ),
    GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (ctx, state) {
          print('state.uri: ${state.uri}\n');
          return ResetPassword(
            url: state.uri,
          );
        }),
    GoRoute(
      path: '/browse',
      name: 'browse',
      builder: (ctx, state) => const BrowseScreen(),
      redirect: (context, state) {
        if (supabase.auth.currentSession == null) {
          return '/intro';
        }
        return null;
      },
    ),
  ],
);
