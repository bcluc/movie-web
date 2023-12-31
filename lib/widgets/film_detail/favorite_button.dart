// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/cubits/my_list/my_list_cubit.dart';
import 'package:movie_web/main.dart';
import 'package:page_transition/page_transition.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton(
    this.filmId, {
    super.key,
  });

  final String filmId;

  void _toggleMyList(BuildContext context, bool isInMyList) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final currentMyList = context.read<MyListCubit>().state;

      await supabase.from('profile').update({
        'my_list': isInMyList ? currentMyList.where((element) => element != filmId).toList() : [...currentMyList, filmId],
      }).eq('id', userId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra! Vui lòng thử lại sau'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    isInMyList ? context.read<MyListCubit>().removeFilms(filmId) : context.read<MyListCubit>().addFilms(filmId);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: isInMyList ? const Text('Đã xoá vào Danh sách của tôi') : const Text('Đã thêm vào Danh sách của tôi'),
        duration: const Duration(seconds: 3),
        action: isInMyList
            ? null
            : SnackBarAction(
                label: 'Xem',
                onPressed: () {
                  // context.read<RouteStackCubit>().push('/my_list_films');
                  // context.read<RouteStackCubit>().printRouteStack();
                  context.go('/browse/my-list');
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isInMyList = context.watch<MyListCubit>().contain(filmId);

    return IconButton.filled(
      onPressed: () => _toggleMyList(context, isInMyList),
      style: IconButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
      ),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween<double>(begin: 0.5, end: 1).animate(animation),
          child: child,
        ),
        child: Icon(
          isInMyList ? Icons.check_rounded : Icons.add_rounded,
        ),
      ),
    );
  }
}
