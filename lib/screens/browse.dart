import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_web/main.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'BROWSE',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            FilledButton(
              onPressed: () async {
                await supabase.auth.signOut();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('See you soon'),
                    ),
                  );

                  context.go('/intro');
                }
              },
              child: Text('Đăng xuất'),
            )
          ],
        ),
      ),
    );
  }
}
