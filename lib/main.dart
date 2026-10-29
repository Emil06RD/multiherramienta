import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_screen.dart';
import 'screens/gender_screen.dart';
import 'screens/person_screen.dart';
import 'screens/universities_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/pokemon_screen.dart';
import 'screens/news_screen.dart';
import 'screens/about_screen.dart';
import 'widgets/common.dart';

void main() => runApp(const MultiHerramientasApp());

class MultiHerramientasApp extends StatelessWidget {
  const MultiHerramientasApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'MultiHerramientas',
    locale: const Locale('es'),
    supportedLocales: const [Locale('es')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF588478)),
      scaffoldBackgroundColor: const Color(0xFFF7F9F7),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
    ),
    routes: {
      '/': (_) => const AppPage(index: 0, child: HomeScreen()),
      '/genero': (_) => const AppPage(index: 1, child: GenderScreen()),
      '/persona': (_) => const AppPage(index: 2, child: PersonScreen()),
      '/universidades': (_) =>
          const AppPage(index: 3, child: UniversitiesScreen()),
      '/clima': (_) => const AppPage(index: 4, child: WeatherScreen()),
      '/pokemon': (_) => const AppPage(index: 5, child: PokemonScreen()),
      '/noticias': (_) => const AppPage(index: 6, child: NewsScreen()),
      '/acerca': (_) => const AppPage(index: 7, child: AboutScreen()),
    },
  );
}
