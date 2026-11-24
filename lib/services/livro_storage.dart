import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/livro.dart';

class LivroStorage {
  static const chave = 'livros';
  final _preferencias = SharedPreferencesAsync();

  Future<List<Livro>> carregar() async {
    final dados = await _preferencias.getString(chave);
    if (dados == null) return [];

    final json = jsonDecode(dados);
    if (json is! List) {
      throw const FormatException('A lista de livros é inválida.');
    }

    return json.map<Livro>((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Livro inválido.');
      }
      return Livro.fromJson(item);
    }).toList();
  }

  Future<void> salvar(List<Livro> livros) async {
    final dados = jsonEncode(livros.map((livro) => livro.toJson()).toList());
    await _preferencias.setString(chave, dados);
  }
}
