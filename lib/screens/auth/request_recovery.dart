import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/utils/validate_email.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestRecovery extends StatefulWidget {
  const RequestRecovery({super.key});

  @override
  State<RequestRecovery> createState() => _RequestRecoveryState();
}

class _RequestRecoveryState extends State<RequestRecovery> {
  final _pageController = PageController(initialPage: 0);

  final _emailController = TextEditingController();
  bool _isProcessing = false;

  void _submit() async {
    final enteredEmail = _emailController.text;

    setState(() {
      _isProcessing = true;
    });

    try {
      await supabase.auth.resetPasswordForEmail(
        enteredEmail,
        redirectTo: 'http://localhost:56441/#/reset-password',
      );

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
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

    setState(() {
      _isProcessing = false;
    });
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
                onTapInside: (event) => context.go('/intro'),
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
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                // Nhập Email
                buildFirstPage(),
                // Xác nhận đã gửi Email khôi phục mật khẩu
                buidSecondPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFirstPage() {
    return StatefulBuilder(
      builder: (ctx, setStateSizedBox) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Khôi phục mật khẩu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const Gap(4),
              const Text(
                'Chúng tôi sẽ gửi đường dẫn Khôi phục mật khẩu đến hòm thư của bạn',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Gap(30),
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
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'viovid@gmail.com',
                        hintStyle: TextStyle(color: Color(0xFFACACAC)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                        isCollapsed: true,
                      ),
                      onChanged: (value) {
                        setStateSizedBox(() {});
                      },
                    ),
                  ],
                ),
              ),
              const Gap(40),
              Align(
                child: _isProcessing
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
                        onPressed: validateEmail(_emailController.text) ? _submit : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Gửi mail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
              ),
              const Gap(60),
              Align(
                child: TextButton(
                  onPressed: () {
                    context.go('/sign-in');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF18BDFA),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_new_rounded),
                      Gap(6),
                      Text(
                        'Trở về trang đăng nhập',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buidSecondPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Nếu có tài khoản tồn tại với email ${_emailController.text},\nbạn sẽ nhận được email hướng dẫn khôi phục mật khẩu.\n\nNếu nó không xuất hiện, vui lòng kiểm tra thư mục spam',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(30),
        TextButton(
          onPressed: () {
            context.go('/sign-in');
          },
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF18BDFA),
          ),
          child: const Text(
            'Trở về trang đăng nhập',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
