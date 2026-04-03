/// Marca uma classe de dados (ex.: configuração aninhada no storybook) para
/// gerar [merge*] via `build_runner` + pacote `storybook_ds_builder`.
///
/// Requisitos:
/// - Construtor não nomeado que recebe todos os campos como parâmetros nomeados.
/// - Campos de instância públicos (nomes que não começam com `_`).
///
/// Veja o README do pacote (seção objetos aninhados e code generation).
class StorybookModel {
  const StorybookModel();
}
