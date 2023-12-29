import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_web/app_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kpaxjjmelbqpllxenpxz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtwYXhqam1lbGJxcGxseGVucHh6Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTY5MzA0NjQ5NCwiZXhwIjoyMDA4NjIyNDk0fQ.hGeExPN7h7gYiOILzPU57vSob9LC1UB-W2o6Z7WGLZs',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
const tmdbApiKey = 'a29284b32c092cc59805c9f5513d3811';
const baseAvatarUrl =
    'https://kpaxjjmelbqpllxenpxz.supabase.co/storage/v1/object/public/avatar/';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Movie Web',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 229, 9, 21),
        ),
        textTheme: GoogleFonts.montserratTextTheme(),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always,
        ),
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi'),
      ],
      locale: const Locale('vi'),
    );
  }
}
