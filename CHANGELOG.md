## [1.3.0] - 2026-06-12

Versão de **refatoração arquitetural e correções de estabilidade**. O pacote foi reorganizado em torno de `AttributeModel` (com `AttributeDto` mantido como `@deprecated` typedef), introduziu um **registry de estratégias** extensível para os editores do painel, expôs uma **`StorybookTheme`** configurável para o chrome do storybook e corrigiu dois crashes de inicialização do `DevicePreview`. **Nenhuma breaking change** — código que rodava em `1.2.5` continua compilando e rodando em `1.3.0` (apenas com avisos de deprecation em `AttributeDto`).

### Added

- **Refatoração `AttributeDto` → `AttributeModel`** com classe canônica em `lib/src/models/model/attribute_model.dart`. `lib/src/models/dto/attribute_dto.dart` agora é apenas um `typedef @deprecated` que aponta para `AttributeModel` — projetos existentes que ainda referenciam `AttributeDto` continuam compilando, mas recebem um aviso de deprecation.
  - **Impacto:** Nenhum para consumidores que já usavam `AttributeModel` (o nome público recomendado desde `1.2.5`). Consumidores que ainda escrevem `AttributeDto` devem migrar para `AttributeModel`; a lib segue exportando o typedef enquanto o ecossistema se atualiza.
  - **Migração:** troca textual `AttributeDto` → `AttributeModel` (mesma API).
- **Registry de estratégias de editor (`AttributeEditorRegistry`)** em `lib/src/widgets/attributes_variant/strategies/`. Substitui a cadeia `if/else is XType` que existia em `attribute_variant.dart` por um **padrão Strategy** com `priority` e fallback configurável.
  - **Impacto:** extensibilidade — apps que precisarem de um editor customizado (ex.: `DateStrategy`, `LocaleStrategy`) podem registrar via `AttributeEditorRegistry.instance.register(...)` em `main()` sem alterar o core da lib. Estratégias padrão (`String`, `Bool`, `Number`, `Function`, `Object`, `Default`) são registradas uma única vez pelo `Storybook.initState`.
  - **Fallback seguro (`SafeNoOpFallback`):** quando nenhuma estratégia aceita um atributo, o painel renderiza um hint em vez de lançar exceção — evita crashes em atributos experimentais.
- **`AttributeValue` (em `lib/src/utils/attribute_value.dart`)** — helpers estáticos (`toDouble`, `toInt`, `toBool`, `valueToString`, `createForType`, `isPresent`) para conversão segura de `VariableOption.value`. Substitui coerções manuais que causavam `TypeError` em sliders (ex.: `bool is not a subtype of double?`).
- **`StorybookTheme` (ThemeExtension)** em `lib/src/theme/` — tokeniza o chrome do storybook (cor de borda do painel, cores do chip selecionado/não-selecionado, cores da toolbar light/dark, título da `AppBar`, cor do asterisco de campo obrigatório, largura do painel colapsável). Acompanha `StorybookThemePresets.{light, dark, cupertino, material3}`.
  - **Impacto:** consumidores que querem alinhar o painel do storybook ao DS do produto passam a poder fazer `storybookTheme: StorybookThemePresets.material3` em vez de aceitar os defaults.
  - **Migração:** nenhum getter novo obrigatório; o getter `StorybookTheme? get storybookTheme => null;` da base `Storybook` continua opcional.
- **Cobertura de testes em `test/`** — 13 novos arquivos cobrindo `AttributeModel`, `StorybookTheme`, `StorybookThemeScope`, `StorybookToolbarColors`, `DevicePreviewStore`, `ContentWidget`, `FunctionAttributeEditor`, reatividade do painel e regressões conhecidas. Estrutura: `test/src/{models,theme,device_preview,widgets}/`.

### Changed

- **Reorganização interna dos exports** em `lib/storybook_ds.dart` — adicionados `StorybookTheme`, `StorybookThemeScope`, `StorybookToolbarColors`, `AttributeChangeBus`, `AttributeEditorRegistry`, `AttributeEditorStrategies`, `AttributeEditorStrategy`, `AttributeValue`. Consumidores que importam `package:storybook_ds/storybook_ds.dart` ganham acesso direto; quem importava paths internos (`package:storybook_ds/src/...`) deve preferir o barrel.
- **`item_attribute_*` reescritos como `AttributeEditorStrategy`** — `StringAttributeEditor`, `BoolAttributeEditor`, `NumberAttributeEditor`, `FunctionAttributeEditor`, `ObjectAttributeEditor`, `DefaultAttributeEditor`. Comportamento de UI idêntico ao de `1.2.5`; apenas a estrutura interna mudou.
- **`item_attribute_object`**: agora delega a atualização do objeto à função `merge` configurada em `ObjectInObjectType`; lança `StateError` explícito se `merge` ou a instância atual estiverem ausentes (mesmo comportamento de `1.2.5`, mensagem de erro mais clara).
- **`Storybook.initState`**: registra as estratégias padrão via `registerStandardAttributeStrategies(AttributeEditorRegistry.instance)` uma única vez por processo (flag estática `_strategiesRegistered`). Consumidores que precisarem registrar uma estratégia própria devem chamar `AttributeEditorRegistry.instance.register(...)` **após** o `super.initState()`.
- **`AttributeChangeBus`**: barramento de mudanças por instância de `Storybook` (não é mais singleton), usado para evitar `setState(() {})` cego em `onUpdateAttributes`.
- **Exemplo em `example/` reescrito** — `CustomCard` agora usa a API `AttributeModel`, declara `@StorybookModel() class CustomCardSettings`, gera `mergeCustomCardSettings` via `build_runner` (configurado em `example/build.yaml`), e o app de exemplo separa temas em `example/lib/sample_themes.dart` (Material 3 via `ColorScheme.fromSeed` para `sage`, `ocean`, `plum`).
- **READMEs (EN e PT-BR)** reescritos para refletir a API `AttributeModel`, o fluxo sem reflexão, o uso do `storybook_ds_builder` para `merge*` e receitas rápidas para os principais tipos de knob.

### Fixed

- **`DevicePreviewStore` "Not initialized"** — crash que ocorria no primeiro frame quando a UI do `DevicePreview` (seção `Device` / `Accessibility` / `Settings` do tool panel) lia seletores (`selectedDevice`, `selectedLocale`, `selectedBrightness`, `selectedOrientation`, etc.) antes do `initialize()` resolver. Os seletores agora têm **fallbacks seguros** para o estado `notInitialized` em vez de lançar `Exception('Not initialized')`. **Impacto:** elimina o crash vermelho no log ao abrir uma story pela primeira vez.
- **`ToolPanel` `ParentDataWidget` no título da `AppBar`** — removido um `Flexible` indevido em torno do título da `AppBar` de ferramentas que disparava assert `A RenderFlex overflowed by N pixels` / `ParentDataWidget` quando o título era longo (ex.: nome de story longo + `ThemeSettings` ativo). **Impacto:** corrige crash visual em telas estreitas / títulos longos.
- **Performance geral do `Storybook`**: `updatePreviewCode` é gerado uma vez por build do bloco, `breakSpaceLevel` otimizado, e a atribuição confusa ao parâmetro de mesmo nome em `updatePreviewCode` foi removida (não muda comportamento observável; só limpeza interna).

### Compatibility

| API | 1.2.5 | 1.3.0 |
|-----|-------|-------|
| `AttributeDto` (typedef) | público | `@deprecated` → aponta para `AttributeModel` (continua exportado, compila com warning) |
| `AttributeModel` | público | público, **classe canônica** |
| `StorybookAttributeFactories` | público | público, sem mudanças |
| `@StorybookModel()` | público | público, sem mudanças |
| `MultipleThemeSettings` / `ThemeSettings` | público | público, sem mudanças |
| `StorybookTheme` | (não existia) | público, opcional |
| `AttributeEditorRegistry` | (interno, sem export) | **público** (para registro de estratégias customizadas) |
| `AttributeValue` | (não existia) | público, utilitário |
| `lib/src/...` paths internos | exportados por conveniência | continuam funcionando, mas prefira `package:storybook_ds/storybook_ds.dart` |

### Migration guide (1.2.5 → 1.3.0)

1. **Opcional (recomendado):** troque `AttributeDto` por `AttributeModel` no seu código. É rename puro.
2. **Sem ação:** se você só usa `AttributeModel`, `StorybookAttributeFactories`, `@StorybookModel()`, `MultipleThemeSettings` e `ThemeSettings`, **não precisa mudar nada**.
3. **Opcional:** se quiser customizar cores do chrome, sobrescreva `storybookTheme` na sua `State extends Storybook<T>`.
4. **Opcional:** se quiser registrar um editor customizado, faça `AttributeEditorRegistry.instance.register(MinhaEstrategia())` no `initState` da sua story, **após** `super.initState()`.

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
