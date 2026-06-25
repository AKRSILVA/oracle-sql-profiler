-- Tabela usada para armazenar os relatorios gerados pelo DBMS_HPROF
-- (Hierarchical Profiler) do Oracle. Cada execucao de profiling gera
-- um relatorio HTML (CLOB) que e inserido aqui para consulta posterior.
--
-- Execute uma unica vez (ex: em ambiente de homologacao).

CREATE TABLE profiler_reports (
    id        NUMBER GENERATED ALWAYS AS IDENTITY,
    trace_id  NUMBER,
    created_at DATE DEFAULT sysdate,
    report    CLOB,
    CONSTRAINT profiler_reports_pk PRIMARY KEY (id)
);
