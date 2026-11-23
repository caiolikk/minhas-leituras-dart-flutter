class Livro {
  static const List<String> statusDisponiveis = [
    'Quero ler',
    'Lendo',
    'Concluído',
  ];

  final String id;
  final String titulo;
  final String autor;
  final String status;

  const Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.status,
  });
}
