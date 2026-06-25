# Oracle SQL Profiler (DBMS_HPROF)

Script manual para medir, em detalhe, onde uma procedure/function PL/SQL gasta tempo, usando o **Hierarchical Profiler** (`DBMS_HPROF`) nativo do Oracle. Os nomes de procedures, tabelas e dados de exemplo são genéricos — substitua pelos da sua aplicação.

## Como o DBMS_HPROF funciona

O `DBMS_HPROF` instrumenta a execução de código PL/SQL e gera uma árvore de chamadas com, para cada sub-rotina (procedure, function, trigger):

- Número de chamadas.
- Tempo próprio (excluindo sub-chamadas).
- Tempo total (incluindo sub-chamadas).
- Quem chamou quem (call graph).

Isso é diferente de um trace SQL (10046): o trace SQL foca no tempo gasto em comandos SQL; o `DBMS_HPROF` foca no tempo gasto dentro do código PL/SQL em si — ótimo para descobrir qual procedure/loop está consumindo o tempo dentro de uma rotina de negócio complexa.

### Fluxo de execução

1. **`dbms_hprof.create_tables`** — cria as tabelas internas (`DBMSHP_*`) onde o profiler grava os dados brutos da execução. Use `force_it => TRUE` para recriar sem erro se já existirem.
2. **`dbms_hprof.start_profiling`** — inicia a coleta e retorna um `trace_id`.
3. **Execução do código a ser medido** — chame normalmente a procedure/function/bloco que você quer analisar.
4. **`dbms_hprof.stop_profiling`** — finaliza a coleta.
5. **`dbms_hprof.analyze`** — processa os dados brutos e gera um relatório HTML (CLOB) com a árvore de chamadas e os tempos.
6. O relatório é salvo em uma tabela própria (`profiler_reports`) para consulta posterior, já que o CLOB pode ser grande e os dados brutos do profiler são voláteis entre sessões/recriações de tabela.

## Pré-requisitos

- Privilégio `EXECUTE` no pacote `DBMS_HPROF`.
- Privilégio para criar tabelas no schema usado (as tabelas internas `DBMSHP_*` e a tabela `profiler_reports`).
- Recomendado rodar primeiro em ambiente de homologação/teste, não em produção — a instrumentação adiciona overhead à execução.

## Estrutura

```
sql/
  01_create_profiler_table.sql      -- cria a tabela onde os relatórios ficam salvos (rodar uma vez)
  02_run_profiler.sql                -- template: envolve start/stop/analyze em torno do código a medir
  03_query_profiler_report.sql       -- consulta os relatórios já gerados
  04_build_param_list_example.sql    -- exemplo opcional: como montar uma lista de parâmetros via LISTAGG
                                         quando a procedure analisada espera esse formato de entrada
```

## Passo a passo de uso

1. Rode `01_create_profiler_table.sql` uma vez (cria `profiler_reports`).
2. Abra `02_run_profiler.sql` e substitua o trecho `-- >>> CODIGO A SER PROFILADO <<<` pela chamada da sua procedure/function, com os parâmetros do seu cenário de teste.
3. Execute o bloco. Ele profila a execução e já insere o relatório em `profiler_reports`.
4. Rode `03_query_profiler_report.sql` para localizar o relatório gerado (ordenado por data).
5. Copie o conteúdo do campo `report` (CLOB) para um arquivo `.html` e abra no navegador para visualizar a árvore de chamadas e os tempos de cada sub-rotina.

## Observações de segurança

Este script foi extraído de um caso de uso real em ambiente corporativo, mas todos os nomes de procedures, tabelas, colunas e dados (IDs de atendimento, usuários, schemas, etc.) foram substituídos por placeholders genéricos. Ao usar este toolkit, substitua os placeholders pelos identificadores do seu próprio ambiente — nenhum dado ou nome específico de empresa está incluído aqui.
