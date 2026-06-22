import 'package:flutter/material.dart';

import 'screens/login.dart';

void main() {
  runApp(const Aplicativo());
}

// Classe principal do aplicativo
class Aplicativo extends StatelessWidget {
  const Aplicativo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja de Artesanato',
      debugShowCheckedModeBanner: false,

      // Define o tema visual do aplicativo
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),

      // Define que a primeira tela será a tela de login
      home: const TelaLogin(),
    );
  }
}
