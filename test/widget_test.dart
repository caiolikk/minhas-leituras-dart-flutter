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

  testWidgets('Cadastra um livro e atualiza a listagem', (tester) async {
    await tester.pumpWidget(const MinhasLeiturasApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Adicionar livro'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '  O Hobbit  ');
    await tester.enterText(find.byType(TextField).at(1), 'J. R. R. Tolkien');

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lendo').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('O Hobbit'), findsOneWidget);
    expect(find.text('J. R. R. Tolkien'), findsOneWidget);
    expect(find.text('Lendo'), findsOneWidget);
    expect(find.text('Livro cadastrado com sucesso.'), findsOneWidget);
  });

  testWidgets('Impede cadastro com campos vazios', (tester) async {
    await tester.pumpWidget(const MinhasLeiturasApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar livro'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), '   ');
    await tester.ensureVisible(find.text('Cadastrar'));
    await tester.tap(find.text('Cadastrar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe o título do livro.'), findsOneWidget);
    expect(find.text('Informe o autor do livro.'), findsOneWidget);
    expect(find.text('Cadastrar livro'), findsOneWidget);
  });

  testWidgets('Cancelar cadastro mantém a lista vazia', (tester) async {
    await tester.pumpWidget(const MinhasLeiturasApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Adicionar livro'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Livro não salvo');
    await tester.ensureVisible(find.text('Cancelar'));
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum livro cadastrado'), findsOneWidget);
    expect(find.text('Livro não salvo'), findsNothing);
  });
}
