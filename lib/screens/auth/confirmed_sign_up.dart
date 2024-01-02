import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';

class ConfirmedSignUp extends StatefulWidget {
  const ConfirmedSignUp({
    super.key,
    required this.url,
  });

  final Uri url;

  @override
  State<ConfirmedSignUp> createState() => _ConfirmedSignUpState();
}

class _ConfirmedSignUpState extends State<ConfirmedSignUp> {
  bool _isProcessing = false;

  Future<void> _redirectToBrowse(BuildContext context) async {
    setState(() {
      _isProcessing = true;
    });

    // https: //supabase.com/docs/guides/auth/passwords
    await supabase.auth.getSessionFromUrl(widget.url);

    if (mounted) {
      context.go('/browse');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: TapRegion(
                onTapInside: (_) => _redirectToBrowse(context),
                child: Image.asset(
                  Assets.viovidLogo,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            color: Color.fromRGBO(0, 0, 0, 0.2),
          ),
          const Spacer(),
          const Text(
            'Xác nhận Email thành công',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          _isProcessing
              ? const SizedBox(
                  height: 44,
                  width: 44,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                )
              : FilledButton(
                  onPressed: () => _redirectToBrowse(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Trang chủ VioVid',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
          const Gap(100),
          const Spacer(),
        ],
      ),
    );
  }
}
