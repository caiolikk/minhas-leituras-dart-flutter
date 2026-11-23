import 'package:flutter/material.dart';

import '../models/livro.dart';

class ListaLivrosScreen extends StatelessWidget {
  final List<Livro> livros;

  const ListaLivrosScreen({super.key, this.livros = const []});

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: livros.isEmpty
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
                      'Seus livros aparecerão aqui.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    final livro = livros[index];

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
