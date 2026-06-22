import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/produto.dart';

// Componente responsável por exibir um produto na lista
class CardProduto extends StatelessWidget {
  final Produto produto;
  final VoidCallback aoEditar;
  final VoidCallback aoExcluir;

  const CardProduto({
    super.key,
    required this.produto,
    required this.aoEditar,
    required this.aoExcluir,
  });

  // Formata o preço para o padrão brasileiro
  String get precoFormatado {
    return 'R\$ ${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  // Função que exibe a imagem do produto
  Widget imagemDoProduto() {
    if (produto.fotoBytes != null) {
      return Image.memory(
        produto.fotoBytes!,
        fit: BoxFit.cover,
      );
    }

    if (!kIsWeb && produto.foto != null) {
      return Image.file(
        produto.foto!,
        fit: BoxFit.cover,
      );
    }

    return Icon(
      Icons.shopping_bag,
      size: 38,
      color: Colors.teal.shade700,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Imagem do produto
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 82,
                height: 82,
                color: Colors.grey.shade200,
                child: imagemDoProduto(),
              ),
            ),

            const SizedBox(width: 12),

            // Nome e preço do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nome,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    precoFormatado,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.teal.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Botão para editar o produto
            IconButton(
              onPressed: aoEditar,
              tooltip: 'Editar',
              icon: const Icon(Icons.edit),
            ),

            // Botão para excluir o produto
            IconButton(
              onPressed: aoExcluir,
              tooltip: 'Excluir',
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
