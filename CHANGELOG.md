## [1.2.5] - 2026-04-03

### Breaking changes

- **Removida a dependência `reflectable`**. Não há mais reflexão em tempo de execução; em Flutter (AOT) isso não é suportado de forma nativa.
- **`AttributeDto.objectInObject`** exige o parâmetro opcional **`merge`** (`StorybookNestedMerge`) para edição de objetos aninhados no painel. Sem `merge`, o fluxo que atualizava o filho via reflexão deixa de existir.
- Removidos **`UtilsReflectable`**, **`UtilsAttributeReflectable`** e **`generateAttributes`**. Use lista manual de `AttributeDto` ou o gerador opcional `storybook_ds_builder` (repositório, pasta `builder/`) com **`@StorybookModel()`**.
- **`StorybookAttributeFactories`** substitui o antigo `UtilsAttributeReflectable.factoryAttributeDtoString` (mesmo comportamento para strings longas de exemplo).

### Added

- **`lib/annotations.dart`**: anotação **`@StorybookModel()`** para geração de funções `merge*` (via `build_runner` + pacote `storybook_ds_builder`).
- **`StorybookNestedMerge`** e campo **`merge`** em **`ObjectInObjectType`** / factory **`AttributeDto.objectInObject`**.
- **`lib/src/utils/attribute_factories.dart`**: **`StorybookAttributeFactories`** exportado pelo pacote.
- Documentação nos README (inglês e PT-BR) sobre fluxo sem reflexão e uso do gerador.

### Fixed

- **`DevicePreview`**: **`dispose()`** passa a encerrar o **`StreamController`** de screenshots (`_onScreenshot`), evitando vazamento ao desmontar o widget.
- **`assert_inherited_media_query`**: compatível com Flutter 3.7+ em que **`useInheritedMediaQuery`** foi descontinuado; o assert não falha mais sem essa flag no `MaterialApp` interno.
- **`StoryBookComponent`**: descarte correto do **`ValueNotifier`** quando o controller é criado internamente; o controller efetivo é repassado ao estado filho (correção de bug quando `widget.controller` era `null`).
- **`DSDropdownContainer`**: **`AnimationController.dispose()`**, remoção do listener no dispose e **`dispose` do `DSDropdownController` apenas quando criado pelo container** (não descarta controller injetado pelo app).
- **`ContentWidget` / `Builders`**: seleção do construtor padrão deixa de usar **`Future.delayed` no `build`**; agendamento único com **`addPostFrameCallback`** + flag.
- **`Storybook`**: geração do código de preview uma vez por build do bloco; **`breakSpaceLevel`** otimizado; remoção de atribuição confusa ao parâmetro em **`updatePreviewCode`**.
- **`StoryBookComponentController.getWhereAttribute`**: não lança mais se o nome do atributo não existir (retorna `null`).

### Changed

- **`item_attribute_object`**: usa **`merge`** do **`ObjectInObjectType`**; lança **`StateError`** explícito se **`merge`** ou instância atual estiver ausente.
- Exemplo no repositório (`example/`): temas de exemplo com **Material 3** (`ColorScheme.fromSeed`), reorganização de stories, nomes mais genéricos e **`builders`** alinhados aos construtores do `CustomCard`.

---

## 1.2.3+22 - Atualização de versões de bibliotecas e melhor compatibilidade com Flutter 3.38
- Atualização das versões das bibliotecas de dependências para melhor compatibilidade com Flutter 3.38
- Removida dependência da biblioteca `collection`, substituída por função local `groupBy` para reduzir dependências externas
- Atualizadas as seguintes bibliotecas: `shared_preferences` para ^2.5.0, `build_runner` para ^2.4.15, `freezed` para ^2.5.8, `json_serializable` para ^6.9.0, `freezed_annotation` para ^2.4.4
- Melhorias na compatibilidade e estabilidade do pacote

## 1.2.4+21 - Adicionar suporte de builder ao StoryBookComponent e limpeza de exports
- Estamos animados em anunciar a versão 1.2.4+21 da nossa biblioteca, que traz uma nova opção poderosa para seus componentes! Agora, além de dados primitivos, você pode usar objetos complexos com a funcionalidade `AttributeDto.objectInObject`. Esta atualização permite maior flexibilidade e riqueza na construção de seus componentes, facilitando a integração de estruturas de dados mais elaboradas.

## 1.2.3+20 - Adicionar suporte de builder ao StoryBookComponent e limpeza de exports
- Introduzido parâmetro opcional `builder` ao `StoryBookComponent` e garantido que `child` ou `builder` seja obrigatório. Refatorados exports em `storybook_ds.dart` para melhor organização e consistência. Também incluídas correções menores no tratamento de atributos e atualizado pubspec.lock para versão 1.2.2+19.

## 1.2.0+19 - Melhorias em recursos visuais 
- Resolvendo problema de abertura de modais quando tela completa

## 1.2.0+18 - Melhorias em recursos visuais 
- Melhorias em recursos visuais 

## 1.1.0+17 - Opcão para poder escolher themas diferentes
- Opcão para poder escolher themas diferentes

## 0.0.16 - Incluir scala e layout do display
- Incluir opção de sugestões quando o tipo for String

## 0.0.15 - Incluir scala e layout do display
- Incluir ferramentas de ajustes de scala e redirecionamento de layout do display

## 0.0.14 - Incluir visualização de Wrap 
- Ajustar visualização para dispositivo mobile 

## 0.0.11 - Incluir visualização de Wrap 
- Correção de problema de compatibilidade de SDK 3.3.10

## 0.0.10 - Incluir visualização de Wrap
- Incluir tabela com valores das variaveis do componente

## 0.0.9 - Incluir visualização de Wrap 
- Experimental MUDANÇA QUEBRANTE: mudanças em implementação da `class` storybook

## 0.0.8 - Incluir visualização de Wrap 
- Incluir visualização de Wrap

## 0.0.7 - Correções de bugs, implementação de edição para valores numéricos
- Correções de bugs, implementação de edição para valores numéricos

## 0.0.5 - Edição de documentação de utilização
- Documentação de utilização

## 0.0.1 - Primeira Publicação
- Publicação do pacote 
