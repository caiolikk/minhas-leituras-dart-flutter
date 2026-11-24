# Minhas Leituras

Aplicativo desenvolvido em Flutter e Dart para a disciplina de Dispositivos Móveis.

Integrante: Caio Henrique Cid Rodrigues Cunha.

## Funcionalidades

Cadastro e listagem de livros com título, autor e status (Quero ler, Lendo ou Concluído), exclusão com confirmação e armazenamento local com shared_preferences.

Os livros são convertidos em JSON e armazenados em uma única chave, recuperada ao iniciar o aplicativo. Não é utilizado banco de dados externo.

## Executar

Com o Flutter e o Android SDK instalados, execute:

```bash
flutter pub get
flutter run
```

Selecione um emulador ou dispositivo Android. Para executar no navegador, use `flutter run -d chrome`.

Para iOS, caso necessário, gere os arquivos de plataforma em um Mac com `flutter create --platforms=ios .` e configure o Xcode.

## Testes

```bash
flutter analyze
flutter test
```

O aplicativo pode ser validado cadastrando livros, fechando e reabrindo o app e confirmando se os registros permanecem. Repita o processo após excluir um livro.
