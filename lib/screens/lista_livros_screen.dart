import 'package:flutter/material.dart';

import '../models/livro.dart';
import '../services/livro_storage.dart';
import 'cadastro_livro_screen.dart';

class ListaLivrosScreen extends StatefulWidget {
  const ListaLivrosScreen({super.key});

  @override
  State<ListaLivrosScreen> createState() => _ListaLivrosScreenState();
}

class _ListaLivrosScreenState extends State<ListaLivrosScreen> {
  final _storage = LivroStorage();
  List<Livro> _livros = [];
  bool _carregando = true;
  bool _salvando = false;
  bool _erroCarregamento = false;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  void _mensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _carregarLivros() async {
    setState(() {
      _carregando = true;
      _erroCarregamento = false;
    });

    try {
      final livros = await _storage.carregar();
      if (!mounted) return;
      setState(() => _livros = livros);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erroCarregamento = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _erroCarregamento) {
          _mensagem('Não foi possível carregar os livros.');
        }
      });
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _salvar(List<Livro> livros, String mensagem) async {
    setState(() => _salvando = true);
    try {
      await _storage.salvar(livros);
      if (!mounted) return;
      setState(() => _livros = livros);
      _mensagem(mensagem);
    } catch (_) {
      if (!mounted) return;
      _mensagem('Não foi possível salvar as alterações. Tente novamente.');
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _abrirCadastro() async {
    final livro = await Navigator.push<Livro>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroLivroScreen()),
    );

    if (!mounted || livro == null) return;
    await _salvar([..._livros, livro], 'Livro cadastrado com sucesso.');
  }

  Future<void> _removerLivro(Livro livro) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover livro?'),
        content: Text('Deseja remover "${livro.titulo}" da sua lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;
    final livros = _livros.where((item) => item.id != livro.id).toList();
    await _salvar(livros, 'Livro removido com sucesso.');
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
        onPressed: _carregando || _salvando || _erroCarregamento
            ? null
            : _abrirCadastro,
        icon: const Icon(Icons.add),
        label: const Text('Adicionar livro'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _erroCarregamento
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Não foi possível carregar sua lista.'),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: _carregarLivros,
                              child: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _lista(tema),
        ),
      ),
    );
  }

  Widget _lista(ThemeData tema) {
    return _livros.isEmpty
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
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _statusLivro(context, livro.status),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remover livro',
                          onPressed: _salvando
                              ? null
                              : () => _removerLivro(livro),
                          icon: const Icon(Icons.delete_outline),
                          color: tema.colorScheme.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
