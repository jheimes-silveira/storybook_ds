# Exemplo — storybook_ds

Demonstra um story (`CustomCard`) **sem** `reflectable`: atributos declarados na mão, objeto aninhado com `merge` gerado por `@StorybookModel`.

## Gerar código (`mergeCustomCardSettings`)

Após alterar `CustomCardSettings` ou a anotação `@StorybookModel`:

```bash
cd example
dart run build_runner build --delete-conflicting-outputs
```

Isso atualiza `lib/custom_card.storybook.g.dart`.

O `build.yaml` restringe o gerador a `lib/custom_card.dart`. Se `pub get` falhar por conflito de versões, o projeto fixa `build_runner: 2.4.13` de propósito.

## Executar

```bash
flutter run -d chrome
```
