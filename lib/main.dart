import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testownik/provider/theme_settings.dart';
import 'package:testownik/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool isDark = sharedPreferences.getBool('is_dark') ?? false;
  Color color = Color(sharedPreferences.getInt('color') ?? 0xFFffb600);
  int fontSize = sharedPreferences.getInt('font_size') ?? 20;
  runApp(MyApp(isDark: isDark, color: color, fontSize: fontSize));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.isDark,
      required this.color,
      required this.fontSize});
  final bool isDark;
  final Color color;
  final int fontSize;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ThemeSettings(isDark, color, fontSize),
        builder: (context, snapshot) {
          // final settings = context.read<ThemeSettings>();
          final settings = Provider.of<ThemeSettings>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Testownik Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: settings.currentColor,
                brightness: Brightness.light,
              ).copyWith(
                secondary: Colors.green[600],
                secondaryContainer: Colors.green[300],
                tertiary: Colors.red[600],
                tertiaryContainer: Colors.red[300],
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                TextTheme(
                  bodySmall: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  displaySmall: GoogleFonts.poppins(
                    fontSize: settings.currentFontSize.toDouble(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: settings.currentColor,
                brightness: Brightness.dark,
              ).copyWith(
                secondary: Colors.green[300],
                secondaryContainer: Colors.green[900],
                tertiary: Colors.red[300],
                tertiaryContainer: Colors.red[900],
              ),
              textTheme: GoogleFonts.poppinsTextTheme(
                TextTheme(
                  bodySmall: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  displaySmall: GoogleFonts.poppins(
                    fontSize: settings.currentFontSize.toDouble(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              useMaterial3: true,
            ),
            themeMode: settings.currentTheme,
            home: const SplashScreen(),
          );
        });
  }
}
