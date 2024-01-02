import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    this.initEmail,
    super.key,
  });

  final String? initEmail;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameControllber = TextEditingController();
  final _dobController = TextEditingController();
  late final _emailController = TextEditingController(text: widget.initEmail);
  final _passwordController = TextEditingController();

  bool _isProcessing = false;

  String _errorText = '';
  void _submit() async {
    final enteredUsername = _usernameControllber.text;
    final enteredDob = _dobController.text;
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;

    _errorText = '';
    if (enteredUsername.isEmpty) {
      _errorText = 'Bạn chưa điền Tên';
    } else if (enteredDob.isEmpty) {
      _errorText = 'Bạn chưa chọn Ngày Sinh';
    } else if (enteredEmail.isEmpty) {
      _errorText = 'Bạn chưa điền Email đăng nhập';
    } else if (enteredPassword.isEmpty) {
      _errorText = 'Bạn chưa nhập Mật khẩu';
    } else if (enteredPassword.length < 6) {
      _errorText = 'Mật khẩu có ít nhất 6 ký tự';
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final List<Map<String, dynamic>> checkDuplicate = await supabase.from('profile').select('email').eq('email', enteredEmail);

      if (checkDuplicate.isEmpty) {
        await supabase.auth.signUp(
          email: enteredEmail,
          password: enteredPassword,
          emailRedirectTo: 'http://localhost:56441/#/cofirmed-sign-up',
          data: {
            'email': enteredEmail,
            'password': enteredPassword,
            'full_name': enteredUsername,
            'dob': enteredDob,
            'avatar_url': 'default_avt.png',
          },
        );
        /*
        Note:
        Sử dụng supabase.auth.signUp() khi đăng ký một email đã tồn tại trong Supabase
        Thì nó không báo lỗi, chạy tiếp chương trình và showSnackBar "Xác thực Email trong Hộp thư đến.""
        
        => Hiện tại, để fix thì cần check xem Email đã tồn tại trong bảng auth.User phía Supabase hay chưa
        */

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xác thực Email trong Hộp thư đến.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        _errorText = 'Email $enteredEmail đã tồn tại.';
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Có lỗi xảy ra, vui lòng thử lại.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _openDatePicker(BuildContext context) async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (chosenDate != null) {
      _dobController.text = vnDateFormat.format(chosenDate);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: TapRegion(
                    onTapInside: (event) => context.go('/intro'),
                    child: Image.asset(
                      Assets.viovidLogo,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
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
          const Gap(30),
          Expanded(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tạo mật khẩu để bắt đầu tư cách thành viên của bạn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const Gap(4),
                  const Text(
                    'Chỉ cần vài bước nữa là bạn sẽ hoàn tất!\nChúng tôi cũng chẳng thích thú gì với các loại giấy tờ.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Gap(24),
                  Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu sắc của border
                        width: 1, // Độ rộng của border
                      ),
                      borderRadius: BorderRadius.circular(10), // Bán kính của border
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tên của bạn',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _usernameControllber,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'VioVid',
                            hintStyle: TextStyle(color: Color(0xFFACACAC)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            isCollapsed: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: TapRegion(
                      onTapInside: (_) => _openDatePicker(context),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black, // Màu sắc của border
                            width: 1, // Độ rộng của border
                          ),
                          borderRadius: BorderRadius.circular(10), // Bán kính của border
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ngày sinh',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IgnorePointer(
                              child: TextField(
                                controller: _dobController,
                                enabled: false,
                                style: const TextStyle(color: Colors.black),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  isCollapsed: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(14),
                  Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu sắc của border
                        width: 1, // Độ rộng của border
                      ),
                      borderRadius: BorderRadius.circular(10), // Bán kính của border
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'viovid@gmail.com',
                            hintStyle: TextStyle(color: Color(0xFFACACAC)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            isCollapsed: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),
                  Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black, // Màu sắc của border
                        width: 1, // Độ rộng của border
                      ),
                      borderRadius: BorderRadius.circular(10), // Bán kính của border
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mật khẩu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextField(
                          controller: _passwordController,
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: '••••••',
                            hintStyle: TextStyle(color: Color(0xFFACACAC)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                            isCollapsed: true,
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Align(
                    child: Text(
                      _errorText,
                      style: errorTextStyle(
                        context,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(12),
                  _isProcessing
                      ? const Center(
                          child: SizedBox(
                            height: 45,
                            width: 45,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                  const Gap(100),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
