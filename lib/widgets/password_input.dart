import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.passwordController,
    required this.onEditingComplete,
  });
  final TextEditingController passwordController;
  final void Function() onEditingComplete;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            controller: widget.passwordController,
            decoration: InputDecoration(
              hintText: '••••••',
              hintStyle: const TextStyle(color: Color(0xFFACACAC)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              isCollapsed: true,
              suffixIcon: widget.passwordController.text.isEmpty
                  ? null
                  : InkWell(
                      onTap: () {
                        setState(() {
                          _isShowPassword = !_isShowPassword;
                        });
                      },
                      child: _isShowPassword
                          ? const Icon(
                              Icons.visibility_off,
                            )
                          : const Icon(
                              Icons.visibility,
                            ),
                    ),
              suffixIconColor: const Color(0xFFACACAC),
              suffixIconConstraints: const BoxConstraints(
                minHeight: 28,
                minWidth: 28,
              ),
            ),
            obscureText: !_isShowPassword,
            onChanged: (value) {
              if (value.isEmpty) {
                _isShowPassword = false;
              }
              if (value.length <= 1) setState(() {});
            },
            onEditingComplete: widget.onEditingComplete,
          ),
        ],
      ),
    );
  }
}
