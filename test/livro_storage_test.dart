import 'package:flutter_test/flutter_test.dart';
import 'package:minhas_leituras/models/livro.dart';
import 'package:minhas_leituras/services/livro_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  const livro = Livro(
    id: '1',
    titulo: 'Dom Casmurro',
    autor: 'Machado de Assis',
    status: 'Concluído',
  );

  setUp(() {
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  test('Serializa e desserializa todos os campos', () {
    final recuperado = Livro.fromJson(livro.toJson());
    expect(recuperado.toJson(), livro.toJson());
  });

  test('Retorna lista vazia quando não há dados', () async {
    expect(await LivroStorage().carregar(), isEmpty);
  });

  test('Recupera os dados salvos em uma nova instância', () async {
    await LivroStorage().salvar([livro]);
    final livros = await LivroStorage().carregar();
    expect(livros.single.toJson(), livro.toJson());
  });

  test('Salva a lista vazia após remoção', () async {
    await LivroStorage().salvar([livro]);
    await LivroStorage().salvar([]);
    expect(await LivroStorage().carregar(), isEmpty);
  });

  test('Não sobrescreve dados corrompidos ao tentar carregar', () async {
    final preferencias = SharedPreferencesAsync();
    await preferencias.setString(LivroStorage.chave, 'json inválido');
    await expectLater(LivroStorage().carregar(), throwsFormatException);
    expect(await preferencias.getString(LivroStorage.chave), 'json inválido');
  });
}
