import 'package:flutter/material.dart';

import 'home_page.dart';

// Tela responsável pelo login do sistema
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  // Controladores usados para capturar os textos digitados
  final controladorNome = TextEditingController();
  final controladorSenha = TextEditingController();

  // Variável usada para mostrar ou esconder a senha
  bool esconderSenha = true;

  // Lista de usuários cadastrados no sistema
  final Map<String, String> usuarios = {
    "admin": "1234",
    "elencassia": "4567",
    "beatriz": "9632",
  };

  // Função que verifica se o usuário e a senha estão corretos
  void verificarLogin() {
    String nomeDigitado = controladorNome.text.trim();
    String senhaDigitada = controladorSenha.text.trim();

    if (usuarios.containsKey(nomeDigitado) &&
        usuarios[nomeDigitado] == senhaDigitada) {
      // Abre a tela principal após o login correto
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      // Mostra uma mensagem caso o login esteja incorreto
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nome ou senha incorretos."),
        ),
      );
    }
  }

  @override
  void dispose() {
    controladorNome.dispose();
    controladorSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tela de Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo para digitar o nome do usuário
            TextField(
              controller: controladorNome,
              decoration: const InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            // Campo para digitar a senha
            TextField(
              controller: controladorSenha,
              obscureText: esconderSenha,
              decoration: InputDecoration(
                labelText: "Senha",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),

                // Ícone usado para mostrar ou ocultar a senha
                suffixIcon: IconButton(
                  icon: Icon(
                    esconderSenha ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      esconderSenha = !esconderSenha;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botão que chama a função de login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: verificarLogin,
                child: const Text("Entrar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
