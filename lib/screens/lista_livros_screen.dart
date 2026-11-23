import 'package:flutter/material.dart';

import '../models/livro.dart';
import 'cadastro_livro_screen.dart';

class ListaLivrosScreen extends StatefulWidget {
  final List<Livro> livros;

  const ListaLivrosScreen({super.key, this.livros = const []});

  @override
  State<ListaLivrosScreen> createState() => _ListaLivrosScreenState();
}

class _ListaLivrosScreenState extends State<ListaLivrosScreen> {
  late final List<Livro> _livros;

  @override
  void initState() {
    super.initState();
    _livros = List<Livro>.of(widget.livros);
  }

  Future<void> _abrirCadastro() async {
    final livro = await Navigator.push<Livro>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroLivroScreen()),
    );

    if (!mounted || livro == null) return;

    setState(() {
      _livros.add(livro);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Livro cadastrado com sucesso.')),
    );
  }

  Widget _statusLivro(BuildContext context, String status) {
    final cores = Theme.of(context).colorScheme;
    final (fundo, texto) = switch (status) {
      'Lendo' => (cores.tertiaryContainer, cores.onTertiaryContainer),
      'Concluído' => (cores.primaryContainer, cores.onPrimaryContainer),
      _ => (cores.secondaryContainer, cores.onSecondaryContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(status, style: TextStyle(color: texto)),
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
            const Text('Minhas Leituras'),
            const SizedBox(height: 4),
            Text(
              'Caio Henrique Cid Rodrigues Cunha',
              style: tema.textTheme.bodySmall,
              softWrap: true,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar livro'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: _livros.isEmpty
              ? ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    const SizedBox(height: 80),
                    Icon(
                      Icons.menu_book_outlined,
                      size: 64,
                      color: tema.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum livro cadastrado',
                      textAlign: TextAlign.center,
                      style: tema.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Toque em Adicionar livro para começar sua lista.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: _livros.length,
                  itemBuilder: (context, index) {
                    final livro = _livros[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              livro.titulo,
                              style: tema.textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(livro.autor),
                            const SizedBox(height: 12),
                            _statusLivro(context, livro.status),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
