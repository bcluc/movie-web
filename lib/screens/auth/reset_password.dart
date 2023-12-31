import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({
    super.key,
    required this.url,
  });

  final Uri url;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _pageController = PageController(initialPage: 0);

  final _passwordController = TextEditingController();
  final _confirmedPasswordController = TextEditingController();

  bool _isProcessing = false;
  String _errorText = '';

  void _submit() async {
    final password = _passwordController.text;
    final confirmedPassword = _confirmedPasswordController.text;

    _errorText = '';
    if (password.isEmpty) {
      _errorText = 'Bạn chưa nhập Mật khẩu mới';
    } else if (password.length < 6) {
      _errorText = 'Mật khẩu phải có ít nhất 6 ký tự';
    } else if (password != confirmedPassword) {
      _errorText = 'Xác nhận mật khẩu không khớp';
    }

    if (_errorText.isEmpty) {
      setState(() {
        _isProcessing = true;
      });

      try {
        // https: //supabase.com/docs/guides/auth/passwords
        await supabase.auth.getSessionFromUrl(widget.url);

        await supabase.auth.updateUser(
          UserAttributes(
            password: confirmedPassword,
          ),
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
                buildFirstPage(),
                buidSecondPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFirstPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorText,
            style: errorTextStyle(context).copyWith(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const Gap(30),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Mật khẩu mới',
              hintStyle: const TextStyle(
                color: Color(0xFFACACAC),
                fontWeight: FontWeight.normal,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              isCollapsed: true,
            ),
            obscureText: true,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(20),
          TextField(
            controller: _confirmedPasswordController,
            decoration: InputDecoration(
              hintText: 'Xác nhận mật khẩu mới',
              hintStyle: const TextStyle(
                color: Color(0xFFACACAC),
                fontWeight: FontWeight.normal,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  width: 2,
                  color: Colors.black,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 20,
              ),
              isCollapsed: true,
            ),
            obscureText: true,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(30),
          _isProcessing
              ? const Center(
                  child: SizedBox(
                    height: 46,
                    width: 46,
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
          const Gap(60),
        ],
      ),
    );
  }

  Widget buidSecondPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Khôi phục mật khẩu thành công.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(30),
        FilledButton(
          onPressed: () => context.go('/browse'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Trang chủ VioVid',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
