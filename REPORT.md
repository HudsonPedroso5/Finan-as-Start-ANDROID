# Fintracker - Auditoria Técnica e Refatoração

## Problemas Encontrados

1. **Dependências de banco de dados e plugins nativos**
   - O projeto original usava `sqflite`, `sqflite_common_ffi`, `path_provider`, `permission_handler`, `file_picker`, `shared_preferences`, `currency_picker` e `events_emitter`.
   - Isso criava acoplamento com Android/desktop e quebrava a execução no Chrome.

2. **Camada de persistência excessivamente acoplada**
   - DAOs, helpers de DB e migrações ocupavam a maior parte do fluxo do app.
   - A base já tinha um "database" em memória no Web, mas continuava usando uma API estilo SQLite.

3. **Compatibilidade Web frágil**
   - Havia imports e fluxos dependentes de `dart:io`, permissões de armazenamento e exportação/importação de arquivo.
   - O fluxo de backup/export não era multiplataforma.

4. **Persistência desnecessária**
   - O app dependia de banco e armazenamento local mesmo sem necessidade do requisito atual.
   - A lógica de onboarding e configurações também dependia de `SharedPreferences`.

5. **Arquitetura e manutenção**
   - Havia muita duplicação entre helpers de IO/Web.
   - Estados e eventos eram controlados por listeners externos em vez de um único estado reativo.

## Correções Realizadas

1. Remoção completa da camada de banco:
   - Eliminados DAOs, migrações e helpers de DB.
   - O estado agora vive somente em memória dentro do `AppCubit`.

2. Remoção de plugins incompatíveis/dispensáveis:
   - `sqflite`
   - `sqflite_common_ffi`
   - `path_provider`
   - `permission_handler`
   - `file_picker`
   - `shared_preferences`
   - `currency_picker`
   - `events_emitter`

3. Recriação do fluxo em memória:
   - Perfil inicial com nome e moeda.
   - Contas, categorias e pagamentos gerenciados pelo Cubit.
   - Edição, criação e exclusão funcionando sem banco.

4. Reescrita multiplataforma:
   - Fluxos que dependiam de IO foram removidos.
   - O app agora abre em Web e Desktop sem código específico de Windows.

5. Limpeza estrutural:
   - Removidos arquivos gerados e artefatos de build.
   - Removidos assets não utilizados.
   - Organização simplificada em blocos claros: modelos, cubit, telas e widgets.

## Dependências Atualizadas

| Pacote | Versão Antiga | Versão Nova |
|---|---:|---:|
| flutter_bloc | ^9.1.1 | ^9.1.1 |
| intl | ^0.20.2 | ^0.20.2 |
| flutter_lints | ^2.0.0 | ^6.0.0 |
| cupertino_icons | ^1.0.8 | ^1.0.8 |

## Correções Realizadas

- Unificação do estado do app em memória.
- Remoção da persistência local e de plugins nativos.
- Reescrita do onboarding, home, accounts, categories, settings e form de pagamento.
- Eliminação de eventos externos e DAOs.
- Remoção de códigos e arquivos não utilizados.

## Alterações para Web

- Removidas dependências de `dart:io`, permissão de storage e file picker.
- Removido backup/export/import baseado em arquivos.
- Estrutura agora funciona apenas com widgets e estado em memória.

## Alterações para Windows

- Eliminado o uso de plugins de banco e filesystem.
- Removidos registrants gerados com referências antigas.
- O app ficou dependente apenas de Flutter e pacotes Dart puros.

## Código Removido

- Banco de dados.
- Serviços de backup/import/export.
- DAOs.
- Eventos externos.
- Dependências nativas desnecessárias.
- Artefatos de build e arquivos gerados.

## Resultado Final

- Windows e Chrome: projeto reestruturado para rodar sem plugins nativos de banco/arquivo.
- Banco de dados: removido.
- Dependências quebradas: removidas.
- Persistência: substituída por memória temporária.

## Observação

O projeto foi reconstruído para priorizar compatibilidade multiplataforma e manutenção.
A persistência foi trocada por memória temporária, conforme solicitado.
