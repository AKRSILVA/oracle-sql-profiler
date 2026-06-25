-- Exemplo (generico) de como montar, via LISTAGG, uma lista de itens
-- pendentes vindos de varias tabelas relacionadas, no formato
-- "TIPO,ID;TIPO,ID;..." -- util quando a procedure a ser profilada
-- (em 02_run_profiler.sql) espera esse tipo de parametro.
--
-- Substitua <tabela_1>..<tabela_n> e os filtros pelas tabelas e
-- condicoes do seu caso de negocio.

SELECT
    listagg(item_type || ',' || item_id || ';', '') WITHIN GROUP (ORDER BY item_type, item_id) AS result
FROM (
    SELECT 'A' AS item_type, to_char(id) AS item_id
    FROM <tabela_1>
    WHERE <coluna_chave> = :chave
      AND <coluna_status> IS NULL

    UNION ALL

    SELECT 'B' AS item_type, to_char(id) AS item_id
    FROM <tabela_2>
    WHERE <coluna_chave> = :chave
      AND <coluna_status> IS NULL
);
