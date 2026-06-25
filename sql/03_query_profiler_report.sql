-- Consulta os relatorios gerados pelo profiler, do mais recente para o mais antigo.
-- O campo "report" e um CLOB com HTML; abra-o em um navegador (ou exporte para
-- .html) para visualizar a arvore de chamadas e os tempos.

SELECT id, trace_id, created_at, report
FROM profiler_reports
ORDER BY created_at DESC;

-- Para limpar relatorios antigos:
-- DELETE FROM profiler_reports WHERE created_at < sysdate - 7;
