import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:minhas_leituras/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const etapa = String.fromEnvironment('ETAPA');
  const titulo = 'O Hobbit';
  const autor = 'J. R. R. Tolkien';

  testWidgets('Persistência no dispositivo: $etapa', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    if (etapa == 'cadastro') {
      expect(find.text('Nenhum livro cadastrado'), findsOneWidget);

      await tester.tap(find.text('Adicionar livro'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).at(0), titulo);
      await tester.enterText(find.byType(TextField).at(1), autor);
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(DropdownButton<String>));
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lendo').last);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Cadastrar'));
      await tester.tap(find.text('Cadastrar'));
      await tester.pumpAndSettle();

      expect(find.text(titulo), findsOneWidget);
      expect(find.text('Livro cadastrado com sucesso.'), findsOneWidget);
    } else if (etapa == 'exclusao') {
      expect(find.text(titulo), findsOneWidget);
      expect(find.text(autor), findsOneWidget);
      expect(find.text('Lendo'), findsOneWidget);

      await tester.tap(find.byTooltip('Remover livro'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();

      expect(find.text(titulo), findsNothing);
      expect(find.text('Livro removido com sucesso.'), findsOneWidget);
    } else if (etapa == 'conferencia') {
      expect(find.text(titulo), findsNothing);
      expect(find.text('Nenhum livro cadastrado'), findsOneWidget);
    } else {
      fail('Informe a etapa do teste por --dart-define=ETAPA.');
    }
  });
}
