-- Template para rodar o DBMS_HPROF (Hierarchical Profiler) em torno de
-- QUALQUER bloco PL/SQL (procedure, function ou bloco anonimo).
--
-- Substitua o trecho marcado com "-- >>> CODIGO A SER PROFILADO <<<"
-- pela chamada que voce quer medir (sua procedure/function de negocio,
-- com os parametros do seu caso de teste).
--
-- O resultado e um relatorio HTML (CLOB) salvo na tabela profiler_reports
-- (ver 01_create_profiler_table.sql), mostrando tempo gasto e numero de
-- chamadas por sub-rotina, em arvore de chamadas.

DECLARE
    report_clob CLOB;
    l_trace_id  NUMBER;
BEGIN
    -- (Re)cria as tabelas internas do profiler (DBMSHP_*). So precisa
    -- ser feito uma vez por schema, mas force_it => TRUE permite recriar
    -- sem erro caso já existam.
    dbms_hprof.create_tables(force_it => TRUE);

    l_trace_id := dbms_hprof.start_profiling;

    -- >>> CODIGO A SER PROFILADO <<<
    -- Exemplo:
    -- minha_procedure(parametro_1 => :valor_1, parametro_2 => :valor_2);

    dbms_hprof.stop_profiling;

    dbms_hprof.analyze(trace_id => l_trace_id, report_clob => report_clob);

    INSERT INTO profiler_reports (trace_id, report)
    VALUES (l_trace_id, report_clob);

    COMMIT;
END;
/
