import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 16),

            // Lista que mostra os produtos cadastrados
            Expanded(
              child: produtos.isEmpty
                  ? const Center(
                      child: Text('Nenhum produto cadastrado.'),
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
