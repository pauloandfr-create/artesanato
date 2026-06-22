import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/produto.dart';
import '../widgets/card_produto.dart';
import 'cadastro_produto.dart';
import 'login.dart';

// Tela principal do sistema, exibida após o login
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista que armazena os produtos cadastrados
  List<Produto> produtos = [];

  // Variáveis usadas para guardar a logo da loja
  File? logoLoja;
  Uint8List? logoLojaBytes;

  // Objeto usado para selecionar imagens da galeria
  final ImagePicker seletorImagem = ImagePicker();

  // Função para escolher a logo da loja
  Future<void> escolherLogo() async {
    try {
      final XFile? imagem = await seletorImagem.pickImage(
        source: ImageSource.gallery,
      );

      if (imagem == null || !mounted) {
        return;
      }

      if (kIsWeb) {
        final Uint8List bytesImagem = await imagem.readAsBytes();

        setState(() {
          logoLojaBytes = bytesImagem;
          logoLoja = null;
        });
      } else {
        setState(() {
          logoLoja = File(imagem.path);
          logoLojaBytes = null;
        });
      }
    } catch (erro) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Não foi possível selecionar a logo da loja.'),
        ),
      );
    }
  }

  // Função que abre a tela de cadastro de produto
  Future<void> adicionarProduto() async {
    final Produto? novoProduto = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(
        builder: (context) => const CadastroProduto(),
      ),
    );

    if (novoProduto != null) {
      setState(() {
        produtos.add(novoProduto);
      });
    }
  }

  // Função que abre a tela para editar um produto
  Future<void> editarProduto(int indice) async {
    final Produto? produtoEditado = await Navigator.push<Produto>(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroProduto(
          produto: produtos[indice],
        ),
      ),
    );

    if (produtoEditado != null) {
      setState(() {
        produtos[indice] = produtoEditado;
      });
    }
  }

  // Função que remove um produto da lista
  void excluirProduto(int indice) {
    setState(() {
      produtos.removeAt(indice);
    });
  }

  // Função que retorna a imagem correta da logo
  ImageProvider? imagemDaLogo() {
    if (logoLojaBytes != null) {
      return MemoryImage(logoLojaBytes!);
    }

    if (!kIsWeb && logoLoja != null) {
      return FileImage(logoLoja!);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool possuiLogo = logoLoja != null || logoLojaBytes != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja de Artesanato'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Voltar para o login',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TelaLogin(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Área onde a logo da loja é exibida
            GestureDetector(
              onTap: escolherLogo,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.teal.shade100,
                backgroundImage: imagemDaLogo(),
                child: !possuiLogo
                    ? Icon(
                        Icons.store,
                        size: 48,
                        color: Colors.teal.shade800,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Toque para escolher a logo da loja',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Lista que mostra os produtos cadastrados
            Expanded(
              child: produtos.isEmpty
                  ? const Center(
                      child: Text('Nenhum produto cadastrado ainda.'),
                    )
                  : ListView.builder(
                      itemCount: produtos.length,
                      itemBuilder: (context, indice) {
                        return CardProduto(
                          produto: produtos[indice],
                          aoEditar: () => editarProduto(indice),
                          aoExcluir: () => excluirProduto(indice),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // Botão usado para adicionar um novo produto
      floatingActionButton: FloatingActionButton(
        onPressed: adicionarProduto,
        tooltip: 'Adicionar produto',
        child: const Icon(Icons.add),
      ),
    );
  }
}
