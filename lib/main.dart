// Integrante: Caio Henrique Cid Rodrigues Cunha

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/lista_livros_screen.dart';

void main() {
  runApp(const MinhasLeiturasApp());
}

class MinhasLeiturasApp extends StatelessWidget {
  const MinhasLeiturasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas Leituras',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF385D50),
        ),
      ),
      home: const ListaLivrosScreen(),
    );
  }
}
