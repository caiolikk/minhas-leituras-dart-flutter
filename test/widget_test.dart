import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minhas_leituras/main.dart';
import 'package:minhas_leituras/models/livro.dart';
import 'package:minhas_leituras/screens/lista_livros_screen.dart';

void main() {
  testWidgets('Exibe o estado inicial sem livros', (tester) async {
    await tester.pumpWidget(const MinhasLeiturasApp());
    await tester.pumpAndSettle();

    expect(find.text('Minhas Leituras'), findsOneWidget);
    expect(find.text('Caio Henrique Cid Rodrigues Cunha'), findsOneWidget);
    expect(find.text('Nenhum livro cadastrado'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Exibe os dados de um livro na lista', (tester) async {
    const livro = Livro(
      id: '1',
      titulo: 'Dom Casmurro',
      autor: 'Machado de Assis',
      status: 'Lendo',
    );

    await tester.pumpWidget(
      const MaterialApp(home: ListaLivrosScreen(livros: [livro])),
    );

    expect(find.text('Dom Casmurro'), findsOneWidget);
    expect(find.text('Machado de Assis'), findsOneWidget);
    expect(find.text('Lendo'), findsOneWidget);
  });
}
