import 'dart:io';
import 'dart:typed_data';

// Classe que representa um produto cadastrado na loja
class Produto {
  String nome;
  String descricao;
  double preco;

  // Foto utilizada quando o aplicativo roda fora do navegador
  File? foto;

  // Foto utilizada quando o aplicativo roda no navegador
  Uint8List? fotoBytes;

  Produto({
    required this.nome,
    required this.descricao,
    required this.preco,
    this.foto,
    this.fotoBytes,
  });
}
