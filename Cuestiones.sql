-- CUESTIÓN 0
SELECT pg_reload_conf();
-- Mostrar todos los parámetros para comprobar si esta bien cambiado
SELECT
    current_setting('logging_collector') AS logging_collector,
    current_setting('log_statement') AS log_statement,
    current_setting('log_duration') AS log_duration,
    current_setting('log_min_duration_statement') AS log_min_duration_statement,
    current_setting('log_line_prefix') AS log_line_prefix,
    current_setting('max_parallel_workers_per_gather') AS max_parallel_workers_per_gather,
    current_setting('max_parallel_workers') AS max_parallel_workers;