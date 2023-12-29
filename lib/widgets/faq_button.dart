import 'package:flutter/material.dart';
import 'package:movie_web/data/static/faq_data.dart';

class FAQButton extends StatefulWidget {
  const FAQButton({
    super.key,
    required this.faq,
  });

  final FAQ faq;

  @override
  State<FAQButton> createState() => _FAQButtonState();
}

class _FAQButtonState extends State<FAQButton> with SingleTickerProviderStateMixin {
  bool isVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _sizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      if (isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 84),
            child: FilledButton(
              onPressed: toggleVisibility,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: const Color.fromARGB(255, 45, 45, 45),
                foregroundColor: Colors.white,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      widget.faq.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      isVisible
                          ? Icons.arrow_downward_outlined
                          : Icons.arrow_forward_rounded,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            child: SizeTransition(
              sizeFactor: _sizeAnimation,
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 45, 45, 45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.faq.answer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
