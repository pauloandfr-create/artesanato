import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/produto.dart';

// Tela usada para cadastrar ou editar produtos
class CadastroProduto extends StatefulWidget {
  final Produto? produto;

  const CadastroProduto({super.key, this.produto});

  @override
  State<CadastroProduto> createState() => _CadastroProdutoState();
}

class _CadastroProdutoState extends State<CadastroProduto> {
  // Chave usada para validar o formulário
  final GlobalKey<FormState> chaveFormulario = GlobalKey<FormState>();

  // Controladores dos campos do formulário
  final TextEditingController controladorNome = TextEditingController();
  final TextEditingController controladorDescricao = TextEditingController();
  final TextEditingController controladorPreco = TextEditingController();

  // Objeto usado para selecionar imagem da galeria
  final ImagePicker seletorImagem = ImagePicker();

  // Variáveis usadas para guardar a foto do produto
  File? fotoSelecionada;
  Uint8List? fotoSelecionadaBytes;

  @override
  void initState() {
    super.initState();

    // Caso receba um produto, os campos são preenchidos para edição
    if (widget.produto != null) {
      controladorNome.text = widget.produto!.nome;
      controladorDescricao.text = widget.produto!.descricao;
      controladorPreco.text = widget.produto!.preco.toStringAsFixed(2);
      fotoSelecionada = widget.produto!.foto;
      fotoSelecionadaBytes = widget.produto!.fotoBytes;
    }
  }

  @override
  void dispose() {
    controladorNome.dispose();
    controladorDescricao.dispose();
    controladorPreco.dispose();
    super.dispose();
  }

  // Função para selecionar a foto do produto
  Future<void> escolherFoto() async {
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
          fotoSelecionadaBytes = bytesImagem;
          fotoSelecionada = null;
        });
      } else {
        setState(() {
          fotoSelecionada = File(imagem.path);
          fotoSelecionadaBytes = null;
        });
      }
    } catch (erro) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Não foi possível escolher a foto.'),
        ),
      );
    }
  }

  // Função que converte o preço digitado em número
  double? converterPreco(String valor) {
    String valorAjustado = valor.replaceAll(',', '.');
    return double.tryParse(valorAjustado);
  }

  // Função que valida e salva os dados do produto
  void salvarProduto() {
    if (!chaveFormulario.currentState!.validate()) {
      return;
    }

    final Produto produto = Produto(
      nome: controladorNome.text.trim(),
      descricao: controladorDescricao.text.trim(),
      preco: converterPreco(controladorPreco.text)!,
      foto: fotoSelecionada,
      fotoBytes: fotoSelecionadaBytes,
    );

    Navigator.pop(context, produto);
  }

  // Função que exibe a foto do produto
  Widget imagemDoProduto() {
    if (fotoSelecionadaBytes != null) {
      return Image.memory(
        fotoSelecionadaBytes!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    if (!kIsWeb && fotoSelecionada != null) {
      return Image.file(
        fotoSelecionada!,
        fit: BoxFit.cover,
        width: double.infinity,
      );
    }

    return const Center(
      child: Icon(Icons.image, size: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool editando = widget.produto != null;
    final bool possuiFoto =
        fotoSelecionada != null || fotoSelecionadaBytes != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar Produto' : 'Cadastrar Produto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: chaveFormulario,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Área para escolher ou visualizar a foto
              GestureDetector(
                onTap: escolherFoto,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: possuiFoto
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imagemDoProduto(),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate, size: 48),
                            SizedBox(height: 8),
                            Text('Selecionar Foto'),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo do nome do produto
              TextFormField(
                controller: controladorNome,
                decoration: const InputDecoration(
                  labelText: 'Nome do Produto',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o nome do produto.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Campo da descrição do produto
              TextFormField(
                controller: controladorDescricao,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe a descrição do produto.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // Campo do preço do produto
              TextFormField(
                controller: controladorPreco,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Preço',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Informe o preço.';
                  }

                  final double? preco = converterPreco(valor);

                  if (preco == null || preco <= 0) {
                    return 'Informe um preço válido.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: escolherFoto,
                icon: const Icon(Icons.photo_library),
                label: const Text('Selecionar Foto'),
              ),

              const SizedBox(height: 12),

              FilledButton.icon(
                onPressed: salvarProduto,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
