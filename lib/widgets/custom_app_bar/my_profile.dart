import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      itemBuilder: (ctx) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              SvgPicture.asset(
                Assets.userIcon,
                width: 24,
              ),
              const Gap(12),
              const Text('Tài khoản'),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: const Row(
            children: [
              Icon(Icons.question_mark_rounded),
              Gap(12),
              Text('Trung tâm trợ giúp'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () async {
            await supabase.auth.signOut();
            if (mounted) {
              context.go('/intro');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text(
                      'Hẹn sớm gặp lại bạn.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 3),
                  width: 300,
                ),
              );
            }
          },
          child: const Row(
            children: [
              Icon(Icons.logout_rounded),
              Gap(12),
              Text('Đăng xuất khỏi VioVid'),
            ],
          ),
        ),
      ],
      tooltip: '',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        /*
        Hiên tại:
        CachedNetworkImage đang có warning sau:
        The webOnlyInstantiateImageCodecFromUrl API is deprecated and will be removed in a future release. Please use
        `createImageCodecFromUrl` from `dart:ui_web` instead.

        Có thể thay thế bằng Image.network() nhưng mà nó không có hiệu ứng đẹp
        */
        child: CachedNetworkImage(
          imageUrl: 'https://kpaxjjmelbqpllxenpxz.supabase.co/storage/v1/object/public/avatar/default_avt.png',
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
          fadeInDuration: const Duration(milliseconds: 300),
          // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
          fadeOutDuration: const Duration(milliseconds: 500),
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
