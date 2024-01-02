import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/cubits/app_bar/app_bar_cubit.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/screens/auth/confirmed_sign_up.dart';
import 'package:movie_web/screens/auth/request_recovery.dart';
import 'package:movie_web/screens/auth/reset_password.dart';
import 'package:movie_web/screens/auth/sign_up.dart';
import 'package:movie_web/screens/auth/sign_in.dart';
import 'package:movie_web/screens/browse.dart';
import 'package:movie_web/screens/intro.dart';
import 'package:movie_web/screens/my_list.dart';

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
      builder: (ctx, state) {
        final parameter = state.uri.queryParameters;
        return SignUpScreen(
          initEmail: parameter['initEmail'],
        );
      },
      redirect: (context, state) {
        if (supabase.auth.currentSession != null) {
          return '/browse';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/cofirmed-sign-up',
      name: 'cofirmed-sign-up',
      builder: (ctx, state) {
        return ConfirmedSignUp(
          url: state.uri,
        );
      },
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
        return ResetPassword(
          url: state.uri,
        );
      },
    ),
    GoRoute(
      path: '/browse',
      name: 'browse',
      builder: (ctx, state) => BlocProvider(
        create: (_) => AppBarCubit(),
        child: const BrowseScreen(),
      ),
      redirect: (context, state) {
        if (supabase.auth.currentSession == null) {
          return '/intro';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: 'my-list',
          name: 'my-list',
          builder: (ctx, state) => BlocProvider(
            create: (_) => AppBarCubit(),
            child: const MyList(),
          ),
        ),
      ],
    ),
  ],
);
