import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:movie_web/data/static/faq_data.dart';
import 'package:movie_web/widgets/faq_button.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  final _emailController = TextEditingController();

  bool _isEmailValid = true;

  bool _validateEmail(String email) {
    // Define a regular expression for a valid email address
    final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');

    return emailRegExp.hasMatch(email);
  }

  void _submitEmailToRegister() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      height: 700,
      child: Column(
        children: [
          const Text(
            'Những câu hỏi thường gặp',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 80),
          for (var faq in faqData) FAQButton(faq: faq),
          const SizedBox(height: 50),
          const Text(
            'Bạn đã sẵn sàng xem chưa? Nhập email để tạo hoặc kích hoạt lại tư cách thành viên của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 40),
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
                const SizedBox(
                  width: 20,
                ),

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
          const Gap(50),
          const Divider(
            height: 8,
            thickness: 8,
            color: Color.fromARGB(255, 35, 35, 35),
          ),
        ],
      ),
    );
  }
}
