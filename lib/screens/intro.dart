import 'package:flutter/material.dart';
import 'package:movie_web/widgets/intro/faq_section.dart';
import 'package:movie_web/widgets/intro/head_section.dart';
import 'package:movie_web/widgets/intro/middle_section.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadSection(),
            const MiddleSection(),
            FAQSection(),
          ],
        ),
      ),
    );
  }
}
