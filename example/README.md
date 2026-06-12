# Exemplo — storybook_ds

Demonstra um story (`CustomCard`) **sem** `reflectable`: atributos declarados na mão, objeto aninhado com `merge` gerado por `@StorybookModel`.

## Atributos do `CustomCard`

| Atributo        | Tipo                  | Origem    | Notas                                                   |
| --------------- | --------------------- | --------- | ------------------------------------------------------- |
| `title`         | `String` (obrigatório)| storybook | Título do card.                                         |
| `description`   | `String?`             | storybook | Texto descritivo.                                       |
| `variant`       | `enum`                | storybook | `inline` (alto contraste) ou `outline` (acento).        |
| `hidden`        | `bool`                | storybook | Esconde a linha de ações.                               |
| `enabled`       | `bool`                | storybook | Aplica opacidade (estado desabilitado).                 |
| `imageDisplay`  | `enum`                | storybook | `none`, `image` (padrão) ou `emptyState`.               |
| `imageUrl`      | `String?`             | storybook | URL válida (ex.: `https://picsum.photos/...`).          |
| `borderEnabled` | `bool`                | storybook | Renderiza uma borda visível em volta do card.           |
| `settings.*`    | objeto aninhado       | storybook | `backgroundColor`, `textColor`, `borderColor`.          |
| `width/height`  | `double?`             | storybook | Tamanho fixo (intervalo).                               |
| `onPositive`/`onNegative` | `Function?`   | storybook | Callbacks dos botões.                                   |
| `textPositive`/`textNegative` | `String?` | storybook | Rótulos dos botões.                                     |

### Imagem no topo do card

O atributo `imageDisplay` (enum) controla a área de imagem:

- **`none`** → sem imagem.
- **`image`** (padrão) → renderiza `Image.network(imageUrl)`. O `imageUrl`
  default é `https://picsum.photos/seed/storybook/600/300` — uma imagem
  pública e estável (não precisa de chave). Em caso de URL vazia ou erro
  de carregamento, cai automaticamente no empty state.
- **`emptyState`** → exibe um placeholder visual (ícone + texto "Sem
  imagem") com cor `surfaceContainerHighest`, contrastando com o fundo do
  card.

### Cores dos `settings`

- **`textColor`**: deixe `null` para que o tema (light/dark) defina automaticamente a cor do texto com contraste — evita texto preto sobre fundo escuro.
- **`backgroundColor`**: sobrescreve o fundo padrão da variante. `null` usa `surfaceContainerHighest` (inline) ou `primary` com 12% (outline).
- **`borderColor`**: sobrescreve a cor da borda quando `borderEnabled` for `true`. `null` usa `colorScheme.outline`.

## Temas

Os temas M3 foram ajustados para usar a paleta tonal do `ColorScheme.fromSeed` em **todos os pontos visíveis**:

- `scaffoldBackgroundColor = colorScheme.surface`
- `cardTheme.color = colorScheme.surfaceContainerHigh`
- `appBarTheme.backgroundColor = colorScheme.surfaceContainer`

Isso garante contraste legível em ambos os modos (light/dark) sem cores fixas.

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
