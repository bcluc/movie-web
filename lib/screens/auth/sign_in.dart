import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/assets.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:movie_web/widgets/password_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isProcessing = false;

  String _errorText = '';

  void _submit() async {
    // check
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;

    _errorText = '';
    if (enteredEmail.isEmpty) {
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
      final authRes = await supabase.auth.signInWithPassword(
        email: enteredEmail,
        password: enteredPassword,
      );

      if (authRes.session != null) {
        // await fetchTopicsData();
        // await fetchProfileData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng nhập thành công.'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );

          context.go('/browse');
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        print(error.message);
        if (error.message == "Invalid login credentials") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tên đăng nhập hoặc mật khẩu sai'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Có lỗi xảy ra, vui lòng thử lại.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (supabase.auth.currentSession != null) {
      context.go('/browse');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                Image.asset(
                  Assets.viovidLogo,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                const Spacer(),
                const Text(
                  'Bạn mới sử dụng VioVid?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const Gap(10),
                FilledButton(
                  onPressed: () {
                    // context.go('/sign-in');
                    context.go('/sign-up');
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'ĐĂNG KÝ',
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
          Expanded(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
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
                        ),
                      ],
                    ),
                  ),
                  const Gap(14),
                  PasswordTextField(
                    passwordController: _passwordController,
                    onEditingComplete: _submit,
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Quên mật khẩu',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(20),
                  Align(
                    child: Text(
                      _errorText,
                      style: errorTextStyle(context),
                    ),
                  ),
                  const Gap(12),
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
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
