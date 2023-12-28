import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(40),
          child: Row(
            children: [
              Image.asset(
                Assets.viovidLogo,
                width: 150,
                fit: BoxFit.cover,
              ),
              const Spacer(),
              const Text(
                'Bạn đã có tài khoản?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Gap(10),
              FilledButton(
                onPressed: () {
                  // context.go('/sign-in');
                  context.go('/sign-in');
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: Color.fromRGBO(0, 0, 0, 0.2),
        ),
      ]),
    );
  }
}
