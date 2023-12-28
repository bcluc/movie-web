import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';

class HeadSection extends StatefulWidget {
  const HeadSection({super.key});

  @override
  State<HeadSection> createState() => _HeadSectionState();
}

class _HeadSectionState extends State<HeadSection> {
  final _emailController = TextEditingController();

  bool _isEmailValid = true;

  void _submitEmailToRegister() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(Assets.backgroundLogin),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                Assets.viovidLogo,
                width: 140,
                fit: BoxFit.cover,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () {
                  // context.go('/sign-in');
                  context.go('/sign-in');
                },
                style: FilledButton.styleFrom(
                  fixedSize: const Size(140, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ĐĂNG NHẬP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Gap(60),
          const Text(
            'Xem trên bất kỳ thiết bị nào',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(10),
          SizedBox(
            /*
            Khi chiều rộng cửa sổ trình duyệt < 800
            thì width = chiều rộng của cửa sổ trình duyệt
            */
            width: min(800, double.infinity),
            child: const Text(
              'Phát trực tuyến trên điện thoại, máy tính bảng, laptop và TV của bạn mà không cần trả thêm phí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Gap(80),
          SizedBox(
            width: min(600, double.infinity),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(87, 0, 0, 0),
                      hintText: 'Email',
                      errorText: _isEmailValid ? null : 'Email không hợp lệ',
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    ),
                    style: const TextStyle(color: Colors.white),
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                ),
                const Gap(20),

                // Sự kiện Đăng ký
                FilledButton(
                  onPressed: _submitEmailToRegister,
                  style: TextButton.styleFrom(
                    fixedSize: const Size(170, 49),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    /* mainAxisSize: MainAxisSize.min để các child được nằm giữa Button */
                    children: [
                      Text(
                        'Bắt đầu',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Icon(Icons.navigate_next)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
