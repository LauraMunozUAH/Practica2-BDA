-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler version: 0.9.4
-- PostgreSQL version: 13.0
-- Project Site: pgmodeler.io
-- Model Author: ---

-- Database creation must be performed outside a multi lined SQL file. 
-- These commands were put in this file only as a convenience.
-- 
-- object: new_database | type: DATABASE --
-- DROP DATABASE IF EXISTS musicos;
CREATE DATABASE musicos;
-- ddl-end --

-- object: public."Musicos" | type: TABLE --
-- DROP TABLE IF EXISTS public."Musicos" CASCADE;
CREATE TABLE public."Musicos" (
	codigo_musico integer NOT NULL,
	"DNI" char(10) NOT NULL,
	"Nombre" text NOT NULL,
	"Direccion" text NOT NULL,
	"Codigo_Postal" integer NOT NULL,
	"Ciudad" text NOT NULL,
	"Provincia" text NOT NULL,
	telefono integer NOT NULL,
	"Instrumentos" text NOT NULL,
	"Codigo_grupo_Grupo" integer NOT NULL,
	CONSTRAINT "Musicos_pk" PRIMARY KEY (codigo_musico),
	CONSTRAINT "Unique_DNI" UNIQUE ("DNI")
);
-- ddl-end --
ALTER TABLE public."Musicos" OWNER TO postgres;
-- ddl-end --

INSERT INTO "Musicos" (
    codigo_musico,"DNI","Nombre","Direccion","Codigo_Postal",
    "Ciudad","Provincia",telefono,"Instrumentos","Codigo_grupo_Grupo"
)
SELECT
    gs,
    'DNI' || gs,
    'Musico_' || gs,
    'Calle ' || gs,
    28000,
    'Madrid',
    'Madrid',
    600000000 + gs,
    'Guitarra',
    floor(random()*200000)+1
FROM generate_series(1,1000000) gs;

-- object: public."Grupo" | type: TABLE --
-- DROP TABLE IF EXISTS public."Grupo" CASCADE;
CREATE TABLE public."Grupo" (
	"Codigo_grupo" integer NOT NULL,
	"Nombre" text NOT NULL,
	"Genero_musical" text NOT NULL,
	"Pais" text NOT NULL,
	"Sitio_web" text NOT NULL,
	CONSTRAINT "Grupo_pk" PRIMARY KEY ("Codigo_grupo")
);
-- ddl-end --
ALTER TABLE public."Grupo" OWNER TO postgres;
-- ddl-end --

INSERT INTO "Grupo" ("Codigo_grupo","Nombre","Genero_musical","Pais","Sitio_web")
SELECT
    gs,
    'Grupo_' || gs,
    (ARRAY['rock','pop','jazz','metal','salsa'])[floor(random()*5)+1],
    'España',
    'www.grupo' || gs || '.com'
FROM generate_series(1,200000) gs;

-- object: public."Conciertos" | type: TABLE --
-- DROP TABLE IF EXISTS public."Conciertos" CASCADE;
CREATE TABLE public."Conciertos" (
	"Codigo_concierto" integer NOT NULL,
	"Fecha_realizacion" date NOT NULL,
	"Pais" text NOT NULL,
	"Ciudad" text NOT NULL,
	"Recinto" text NOT NULL,
	CONSTRAINT "Conciertos_pk" PRIMARY KEY ("Codigo_concierto")
);
-- ddl-end --
ALTER TABLE public."Conciertos" OWNER TO postgres;
-- ddl-end --

INSERT INTO "Conciertos" (
    "Codigo_concierto","Fecha_realizacion","Pais","Ciudad","Recinto"
)
SELECT
    gs,
    CURRENT_DATE,
    (ARRAY['España','Francia','Italia'])[floor(random()*3)+1],
    'Ciudad_' || gs,
    'Recinto_' || gs
FROM generate_series(1,100000) gs;

-- object: public."Discos" | type: TABLE --
-- DROP TABLE IF EXISTS public."Discos" CASCADE;
CREATE TABLE public."Discos" (
	"Codigo_disco" integer NOT NULL,
	"Titulo" text NOT NULL,
	"Fecha_edicion" date NOT NULL,
	"Genero" text NOT NULL,
	"Formato" text NOT NULL,
	"Codigo_grupo_Grupo" integer NOT NULL,
	CONSTRAINT "Discos_pk" PRIMARY KEY ("Codigo_disco")
);
-- ddl-end --
ALTER TABLE public."Discos" OWNER TO postgres;
-- ddl-end --

INSERT INTO "Discos" (
    "Codigo_disco","Titulo","Fecha_edicion","Genero","Formato","Codigo_grupo_Grupo"
)
SELECT
    gs,
    'Disco_' || gs,
    CURRENT_DATE,
    (ARRAY['rock','pop','jazz'])[floor(random()*3)+1],
    'CD',
    floor(random()*200000)+1
FROM generate_series(1,1000000) gs;

-- object: "Grupo_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Discos" DROP CONSTRAINT IF EXISTS "Grupo_fk" CASCADE;
ALTER TABLE public."Discos" ADD CONSTRAINT "Grupo_fk" FOREIGN KEY ("Codigo_grupo_Grupo")
REFERENCES public."Grupo" ("Codigo_grupo") MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: public."Canciones" | type: TABLE --
-- DROP TABLE IF EXISTS public."Canciones" CASCADE;
CREATE TABLE public."Canciones" (
	"Codigo_cancion" integer NOT NULL,
	"Nombre" text NOT NULL,
	"Compositor" text NOT NULL,
	"Fecha_grabacion" date NOT NULL,
	"Duracion" time NOT NULL,
	"Codigo_disco_Discos" integer NOT NULL,
	CONSTRAINT "Canciones_pk" PRIMARY KEY ("Codigo_cancion")
);
-- ddl-end --
ALTER TABLE public."Canciones" OWNER TO postgres;
-- ddl-end --

-- object: "Discos_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Canciones" DROP CONSTRAINT IF EXISTS "Discos_fk" CASCADE;
ALTER TABLE public."Canciones" ADD CONSTRAINT "Discos_fk" FOREIGN KEY ("Codigo_disco_Discos")
REFERENCES public."Discos" ("Codigo_disco") MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

INSERT INTO "Canciones" (
    "Codigo_cancion","Nombre","Compositor","Fecha_grabacion","Duracion","Codigo_disco_Discos"
)
SELECT
    gs,
    'Cancion_' || gs,
    'Autor_' || gs,
    CURRENT_DATE,
    (INTERVAL '1 second' * (120 + floor(random()*300)))::time,
    floor(random()*1000000)+1
FROM generate_series(1,12000000) gs;

-- object: public."Entradas" | type: TABLE --
-- DROP TABLE IF EXISTS public."Entradas" CASCADE;
CREATE TABLE public."Entradas" (
	"Codigo_entrada" integer NOT NULL,
	"Localidad" text NOT NULL,
	"Precio" money NOT NULL,
	"Usuario" text NOT NULL,
	"Codigo_concierto_Conciertos" integer NOT NULL,
	CONSTRAINT "Entradas_pk" PRIMARY KEY ("Codigo_entrada")
);
-- ddl-end --
ALTER TABLE public."Entradas" OWNER TO postgres;
-- ddl-end --

-- object: "Conciertos_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Entradas" DROP CONSTRAINT IF EXISTS "Conciertos_fk" CASCADE;
ALTER TABLE public."Entradas" ADD CONSTRAINT "Conciertos_fk" FOREIGN KEY ("Codigo_concierto_Conciertos")
REFERENCES public."Conciertos" ("Codigo_concierto") MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: "Grupo_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Musicos" DROP CONSTRAINT IF EXISTS "Grupo_fk" CASCADE;
ALTER TABLE public."Musicos" ADD CONSTRAINT "Grupo_fk" FOREIGN KEY ("Codigo_grupo_Grupo")
REFERENCES public."Grupo" ("Codigo_grupo") MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

INSERT INTO "Entradas" (
    "Codigo_entrada","Localidad","Precio","Usuario","Codigo_concierto_Conciertos"
)
SELECT
    gs,
    'Zona_' || gs,
    ((random()*80+20)::numeric(10,2))::money,
    'Usuario_' || gs,
    floor(random()*100000)+1
FROM generate_series(1,24000000) gs;

-- object: public."Grupos_Tocan_Conciertos" | type: TABLE --
-- DROP TABLE IF EXISTS public."Grupos_Tocan_Conciertos" CASCADE;
CREATE TABLE public."Grupos_Tocan_Conciertos" (
	"Codigo_grupo_Grupo" integer NOT NULL,
	"Codigo_concierto_Conciertos" integer NOT NULL,
	CONSTRAINT "Grupos_Tocan_Conciertos_pk" PRIMARY KEY ("Codigo_grupo_Grupo","Codigo_concierto_Conciertos")
);
-- ddl-end --

-- object: "Grupo_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Grupos_Tocan_Conciertos" DROP CONSTRAINT IF EXISTS "Grupo_fk" CASCADE;
ALTER TABLE public."Grupos_Tocan_Conciertos" ADD CONSTRAINT "Grupo_fk" FOREIGN KEY ("Codigo_grupo_Grupo")
REFERENCES public."Grupo" ("Codigo_grupo") MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: "Conciertos_fk" | type: CONSTRAINT --
-- ALTER TABLE public."Grupos_Tocan_Conciertos" DROP CONSTRAINT IF EXISTS "Conciertos_fk" CASCADE;
ALTER TABLE public."Grupos_Tocan_Conciertos" ADD CONSTRAINT "Conciertos_fk" FOREIGN KEY ("Codigo_concierto_Conciertos")
REFERENCES public."Conciertos" ("Codigo_concierto") MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

INSERT INTO "Grupos_Tocan_Conciertos"
SELECT DISTINCT
    g,
    floor(random()*100000)+1
FROM generate_series(1,200000) g,
generate_series(1,15);


-- CUESTIÓN 9
WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

EXPLAIN
WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

-- CUESTIÓN 10
CREATE INDEX idx_musicos_grupo
ON "Musicos"("Codigo_grupo_Grupo");

CREATE INDEX idx_conciertos_pais
ON "Conciertos"("Pais");

CREATE INDEX idx_entradas_precio
ON "Entradas"("Precio");

CREATE INDEX idx_gtc_concierto
ON "Grupos_Tocan_Conciertos"("Codigo_concierto_Conciertos");

CREATE INDEX idx_discos_genero
ON "Discos"("Genero");

CREATE INDEX idx_canciones_duracion
ON "Canciones"("Duracion");

SET work_mem = '256MB';

WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

EXPLAIN
WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

-- CUESTIÓN 11
DELETE FROM "Musicos"
WHERE codigo_musico IN (
    SELECT codigo_musico
    FROM "Musicos"
    ORDER BY random()
    LIMIT (SELECT COUNT(*) * 0.30 FROM "Musicos")
);

-- CUESTIÓN 12

WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

EXPLAIN
WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

--CUESTIÓN 14
-- Creación de Índices Compuestos (Optimización de JOIN + Selección)
CREATE INDEX idx_compuesto_entradas_precio ON "Entradas" ("Codigo_concierto_Conciertos", "Precio");

-- Aplicación de la técnica CLUSTER (Reorganización física)
CLUSTER "Entradas" USING idx_compuesto_entradas_precio;
CLUSTER "Musicos" USING idx_musicos_grupo;

-- Mantenimiento y actualización de estadísticas
ANALYZE;

WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";

EXPLAIN
WITH grupos_validos AS (
    SELECT m."Codigo_grupo_Grupo"
    FROM "Musicos" m
    GROUP BY m."Codigo_grupo_Grupo"
    HAVING COUNT(*) > 3
),
grupos_conciertos_espana AS (
    SELECT DISTINCT gtc."Codigo_grupo_Grupo"
    FROM "Grupos_Tocan_Conciertos" gtc
    JOIN "Conciertos" c
        ON gtc."Codigo_concierto_Conciertos" = c."Codigo_concierto"
    JOIN "Entradas" e
        ON c."Codigo_concierto" = e."Codigo_concierto_Conciertos"
    WHERE c."Pais" = 'España'
      AND e."Precio"::numeric BETWEEN 20 AND 50
),
grupos_discos_rock AS (
    SELECT DISTINCT d."Codigo_grupo_Grupo"
    FROM "Discos" d
    JOIN "Canciones" c
        ON d."Codigo_disco" = c."Codigo_disco_Discos"
    WHERE d."Genero" = 'rock'
      AND c."Duracion" > '00:03:00'
)
SELECT
    (COUNT(DISTINCT m.codigo_musico) * 100.0) /
    (SELECT COUNT(*) FROM "Musicos") AS porcentaje
FROM "Musicos" m
JOIN grupos_validos gv
    ON m."Codigo_grupo_Grupo" = gv."Codigo_grupo_Grupo"
JOIN grupos_conciertos_espana gce
    ON m."Codigo_grupo_Grupo" = gce."Codigo_grupo_Grupo"
JOIN grupos_discos_rock gdr
    ON m."Codigo_grupo_Grupo" = gdr."Codigo_grupo_Grupo";