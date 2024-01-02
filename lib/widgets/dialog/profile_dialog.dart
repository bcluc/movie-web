import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_web/data/dynamic/profile_data.dart';
import 'package:movie_web/main.dart';
import 'package:movie_web/utils/common_variables.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:path/path.dart' as path;

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({super.key});

  @override
  State<ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  final _formKey = GlobalKey<FormState>();

  // Hình ảnh lấy từ device
  File? chosenAvatar;

  final _usernameControllber = TextEditingController(text: profileData['full_name']);
  final _dobController = TextEditingController(text: profileData['dob']);

  bool _isProcessing = false;

  Future<void> _pickAvatar() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        chosenAvatar = File(pickedImage.path);
      });
    }
  }

  Future<void> _openDatePicker() async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      initialDate: vnDateFormat.parse(profileData['dob']),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (chosenDate != null) {
      _dobController.text = vnDateFormat.format(chosenDate);
    }
  }

  Future<void> _updateUserInfo() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final enteredUsername = _usernameControllber.text;
    final enteredDob = _dobController.text;

    String extensionImage = "";

    if (chosenAvatar != null) {
      // extensionImage = path.extension(chosenAvatar!.path);
      // await supabase.storage.from('avatar').upload(
      //       '${supabase.auth.currentUser!.email!}$extensionImage',
      //       chosenAvatar!,
      //       fileOptions: const FileOptions(upsert: true),
      //     );
    }

    try {
      /*
    Cập nhật vào Database server
      - Cập nhật thông tin vào bảng profile
      - Cập nhật avatar ở Storage
    */

      final updatedInfo = {
        'full_name': enteredUsername,
        'dob': enteredDob,
      };

      // if (chosenAvatar != null) {
      //   updatedInfo.addAll(
      //     {
      //       'avatar_url': '${supabase.auth.currentUser!.email!}$extensionImage',
      //     },
      //   );
      // }

      // print('updatedInfo = $updatedInfo');

      await supabase.from('profile').update(updatedInfo).eq(
            'id',
            supabase.auth.currentUser!.id,
          );

      // Cập nhật vào local
      profileData['full_name'] = enteredUsername;
      profileData['dob'] = enteredDob;

      // if (chosenAvatar != null) {
      //   profileData['avatar_url'] = '${supabase.auth.currentUser!.email!}$extensionImage';
      // }

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Cập nhật thông tin thành công.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
          width: 400,
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(true);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thất bại. Vui lòng thử lại sau!'),
        ),
      );
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color(0xFF111111),
      child: Ink(
        width: min(MediaQuery.sizeOf(context).width * 0.7, 900),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Gap(56),
                const Text(
                  'Hồ sơ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: IconButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 32,
                  ),
                ),
              ],
            ),
            const Gap(20),
            Row(
              children: [
                Container(
                  height: 260,
                  width: 260,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 51, 51, 51),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      chosenAvatar == null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '$baseAvatarUrl${profileData['avatar_url']}?t=${DateTime.now()}',
                              height: 260,
                              width: 260,
                              fit: BoxFit.cover,
                              // fadeInDuration: là thời gian xuất hiện của Image khi đã load xong
                              fadeInDuration: const Duration(milliseconds: 400),
                              // fadeOutDuration: là thời gian biến mất của placeholder khi Image khi đã load xong
                              fadeOutDuration: const Duration(milliseconds: 800),
                              placeholder: (context, url) => const Padding(
                                padding: EdgeInsets.all(56),
                                child: CircularProgressIndicator(
                                  strokeCap: StrokeCap.round,
                                  strokeWidth: 3,
                                ),
                              ),
                            )
                          : Image.network(
                              chosenAvatar!.path,
                              height: 260,
                              width: 260,
                              fit: BoxFit.cover,
                            ),
                      IconButton(
                        onPressed: _pickAvatar,
                        style: IconButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.image_rounded,
                          size: 28,
                        ),
                      )
                    ],
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: SizedBox(
                    height: 260,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 51, 51, 51),
                            hintText: supabase.auth.currentUser!.email,
                            hintStyle: const TextStyle(color: Color(0xFFACACAC)),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                          ),
                          enabled: false,
                          style: const TextStyle(color: Colors.white),
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: _usernameControllber,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 51, 51, 51),
                              hintText: 'Tên của bạn',
                              hintStyle: TextStyle(color: Color(0xFFACACAC)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isCollapsed: true,
                              contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 20),
                              errorStyle: TextStyle(fontSize: 16),
                            ),
                            style: const TextStyle(color: Colors.white),
                            autocorrect: false,
                            enableSuggestions: false, // No work+
                            keyboardType:
                                TextInputType.emailAddress, // Trick: disable suggestions
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Bạn chưa nhập Tên';
                              }
                              return null;
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: _openDatePicker,
                          child: TextField(
                            controller: _dobController,
                            enabled: false,
                            mouseCursor: SystemMouseCursors.click,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 51, 51, 51),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              isCollapsed: true,
                              contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 20),
                              suffixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Icon(
                                  Icons.edit_calendar,
                                  color: Color(0xFFACACAC),
                                ),
                              ),
                              errorStyle: TextStyle(fontSize: 14),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        _isProcessing
                            ? const SizedBox(
                                height: 46,
                                width: 46,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              )
                            : FilledButton(
                                onPressed: _updateUserInfo,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cập nhật',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const Gap(30),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.3),
            ),
            const Gap(30),
            const ChangePasswordCompose(),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordCompose extends StatefulWidget {
  const ChangePasswordCompose({super.key});

  @override
  State<ChangePasswordCompose> createState() => _ChangePasswordComposeState();
}

class _ChangePasswordComposeState extends State<ChangePasswordCompose> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _changePassword() async {
    // print("Old Password: " + profileData['password']);
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await supabase.auth.updateUser(
        UserAttributes(
          password: _newPasswordController.text,
        ),
      );
    } on AuthException catch (e) {
      print(e.message);
    }

    await supabase.from('profile').update(
      {
        'password': _newPasswordController.text,
      },
    ).eq('id', supabase.auth.currentUser!.id);

    profileData['password'] = _newPasswordController.text;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đổi mật khẩu thành công.'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop();
    }

    setState(() {
      _isProcessing = false;
    });

    // final verifyOldPassword = profileData['password'] == _oldPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 51, 51),
                    hintText: 'Mật khẩu cũ',
                    hintStyle: TextStyle(color: Color(0xFFACACAC)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 20),
                    errorStyle: TextStyle(fontSize: 16),
                    errorMaxLines: 2,
                  ),
                  style: const TextStyle(color: Colors.white),
                  autocorrect: false,
                  enableSuggestions: false, // No work+
                  keyboardType: TextInputType.emailAddress, // Trick: disable suggestions
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập Mật khẩu cũ';
                    }
                    if (value != profileData['password']) {
                      return 'Mật khẩu cũ không đúng.';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(20),
              Expanded(
                child: TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 51, 51),
                    hintText: 'Mật khẩu mới',
                    hintStyle: TextStyle(color: Color(0xFFACACAC)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 20),
                    errorStyle: TextStyle(fontSize: 16),
                    errorMaxLines: 2,
                  ),
                  style: const TextStyle(color: Colors.white),
                  autocorrect: false,
                  enableSuggestions: false, // No work+
                  keyboardType: TextInputType.emailAddress, // Trick: disable suggestions
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa nhập Mật khẩu mới';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu gồm 6 ký tự trở lên.';
                    }
                    if (_oldPasswordController.text == profileData['password'] &&
                        value == profileData['password']) {
                      return 'Mật khẩu mới không được trùng với mật khẩu cũ.';
                    }
                    return null;
                  },
                ),
              ),
              const Gap(20),
              Expanded(
                child: TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 51, 51, 51),
                    hintText: 'Xác nhận Mật khẩu mới',
                    hintStyle: TextStyle(color: Color(0xFFACACAC)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.fromLTRB(16, 24, 16, 20),
                    errorStyle: TextStyle(fontSize: 16),
                    errorMaxLines: 2,
                  ),
                  style: const TextStyle(color: Colors.white),
                  autocorrect: false,
                  enableSuggestions: false, // No work+
                  keyboardType: TextInputType.emailAddress, // Trick: disable suggestions
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Bạn chưa xác nhận Mật khẩu mới';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Mật khẩu xác nhận không khớp';
                    }
                    return null;
                  },
                ),
              )
            ],
          ),
          const Gap(20),
          _isProcessing
              ? const SizedBox(
                  height: 46,
                  width: 46,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                    ),
                  ),
                )
              : FilledButton(
                  onPressed: () => _changePassword(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Đổi mật khẩu',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
