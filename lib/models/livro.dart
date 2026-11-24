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

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'autor': autor,
        'status': status,
      };

  factory Livro.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final titulo = json['titulo'];
    final autor = json['autor'];
    final status = json['status'];

    if (id is! String ||
        id.trim().isEmpty ||
        titulo is! String ||
        titulo.trim().isEmpty ||
        autor is! String ||
        autor.trim().isEmpty ||
        status is! String ||
        !statusDisponiveis.contains(status)) {
      throw const FormatException('Dados de livro inválidos.');
    }

    return Livro(id: id, titulo: titulo, autor: autor, status: status);
  }
}
