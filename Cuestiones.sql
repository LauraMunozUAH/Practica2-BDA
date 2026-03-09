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

--CUESTIÓN 2
CREATE TABLE estudiantes (
    carnet NUMERIC PRIMARY KEY,
    nombre TEXT,
    apellidos TEXT,
    creditos NUMERIC
);
CREATE TABLE asignaturas (
    codigo NUMERIC PRIMARY KEY,
    nombre TEXT,
    caracter TEXT,
    creditos NUMERIC
);
CREATE TABLE matriculas (
    carnet_estu NUMERIC,
    codigo_asig NUMERIC,
    nota NUMERIC,
    PRIMARY KEY (carnet_estu, codigo_asig),
    FOREIGN KEY (carnet_estu) REFERENCES estudiantes(carnet) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY (codigo_asig) REFERENCES asignaturas(codigo) ON DELETE RESTRICT ON UPDATE RESTRICT
);

COPY estudiantes(carnet,nombre, apellidos, creditos)
FROM 'C:\datos_estudiantes.csv'
WITH (DELIMITER ',', FORMAT csv, HEADER false);

COPY asignaturas(codigo,nombre, caracter, creditos)
FROM 'C:\datos_asignaturas.csv'
WITH (DELIMITER ',', FORMAT csv, HEADER false);

COPY matriculas(carnet_estu,codigo_asig, nota)
FROM 'C:\datos_matriculas.csv'
WITH (DELIMITER ',', FORMAT csv, HEADER false);

--CUESTIÓN 3
SELECT relname, reltuples, relpages
FROM pg_class
WHERE relname IN ('estudiantes','asignaturas','matriculas');

ANALYZE estudiantes;
ANALYZE asignaturas;
ANALYZE matriculas;