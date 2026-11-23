import 'dart:math';

import 'package:flutter/material.dart';

import '../models/livro.dart';

class CadastroLivroScreen extends StatefulWidget {
  const CadastroLivroScreen({super.key});

  @override
  State<CadastroLivroScreen> createState() => _CadastroLivroScreenState();
}

class _CadastroLivroScreenState extends State<CadastroLivroScreen> {
  final _tituloController = TextEditingController();
  final _autorController = TextEditingController();
  String _status = Livro.statusDisponiveis.first;
  String? _erroTitulo;
  String? _erroAutor;

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    super.dispose();
  }

  void _cadastrar() {
    final titulo = _tituloController.text.trim();
    final autor = _autorController.text.trim();

    setState(() {
      _erroTitulo = titulo.isEmpty ? 'Informe o título do livro.' : null;
      _erroAutor = autor.isEmpty ? 'Informe o autor do livro.' : null;
    });

    if (_erroTitulo != null || _erroAutor != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha os campos obrigatórios.')),
      );
      return;
    }

    final id = '${DateTime.now().microsecondsSinceEpoch}-'
        '${Random().nextInt(1 << 30)}';

    Navigator.pop(
      context,
      Livro(id: id, titulo: titulo, autor: autor, status: _status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        backgroundColor: tema.colorScheme.surfaceContainer,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cadastrar livro', softWrap: true),
            const SizedBox(height: 4),
            Text(
              'Caio Henrique Cid Rodrigues Cunha',
              style: tema.textTheme.bodySmall,
              softWrap: true,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  'Dados do livro',
                  style: tema.textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('Informe o título, o autor e o status da leitura.'),
                const SizedBox(height: 24),
                TextField(
                  controller: _tituloController,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  onChanged: (valor) {
                    if (_erroTitulo != null && valor.trim().isNotEmpty) {
                      setState(() => _erroTitulo = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Título',
                    errorText: _erroTitulo,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _autorController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  onChanged: (valor) {
                    if (_erroAutor != null && valor.trim().isNotEmpty) {
                      setState(() => _erroAutor = null);
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Autor',
                    errorText: _erroAutor,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Status da leitura',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      items: Livro.statusDisponiveis.map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor == null) return;
                        setState(() => _status = valor);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _cadastrar,
                  icon: const Icon(Icons.check),
                  label: const Text('Cadastrar'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
