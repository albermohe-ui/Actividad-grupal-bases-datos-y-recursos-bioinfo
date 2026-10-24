CREATE DATABASE bd_genomica; -- crea la base de datos
USE bd_genomica; -- selecciona la base de datos


CREATE TABLE GEN( -- crea la tabla GEN
	nombre_gen VARCHAR(100) NOT NULL, -- nombre del gen, obligatorio
    localizacion_gen VARCHAR(100), -- localzacion del gen 
    descripcion_gen VARCHAR(225) NOT NULL, -- descripcion del gen, obligatorio 
    
    PRIMARY KEY (nombre_gen) -- define nombre_gen como clave primaria 
);


CREATE TABLE SECUENCIA ( -- crea la tabla SECUENCIA
	Id_secuencia INT NOT NULL AUTO_INCREMENT, -- identificador unico de la secuencia
    nombre_gen VARCHAR(100) NOT NULL, -- gen al que pertecene la secuencia
    repr_cad_ADN VARCHAR(1000) NOt NULL, -- cadena de ADN, maximo 1000 caracteres
    tipo_sec VARCHAR(50), -- tipo de secuencia: exon, intron, CDS, promotor, etc.
    pos_rel_gen_sec INT NOT NULL, -- posicion relativa de la secuencia dentro del gen 
    PRIMARY KEY (Id_secuencia), -- define Id_secuencia como clave primaria 
    FOREIGN KEY (nombre_gen) REFERENCES GEN(nombre_gen), -- relaciona la secuencia con GEN
    CHECK (CHAR_LENGTH(repr_cad_ADN) BETWEEN 10 AND 1000), -- obliga a que el ADN tenga entre 10 y 1000 Caracteres
    CHECK (pos_rel_gen_sec > 0) -- obliga a que la posicion sea un entero positivo 
    
    
);


CREATE TABLE VARIANTE( -- crea latabla VARIANTE
	Id_var INT NOT NULL AUTO_INCREMENT, -- identificador unico de la variante 
    Id_secuencia INT NOT NULL, -- secuencia donde se encuentra la variante
    alelo_ref VARCHAR(50) NOT NULL DEFAULT '-', -- alelo por referencia; por defecto '-'
    alelo_mut VARCHAR(50) NOT NULL DEFAULT '-', -- alelo mutado; por defecto '-'
    tipo_var VARCHAR(50), -- tipo de variante: SNP, insercion, delecion, etc.
    pos_rel_gen_var INT NOT NULL, -- posicion relativa de la variante
    PRIMARY KEY (Id_var), -- define Id_var como clave primaria
    FOREIGN KEY (Id_secuencia) REFERENCES SECUENCIA(Id_secuencia), -- conecta con SECUENCIA
    CHECK (pos_rel_gen_var > 0) -- obliga a que la posicion sea positiva
);

CREATE TABLE ANOTACION( -- crea la tabla ANOTACION
	Id_anotacion INT NOT NULL AUTO_INCREMENT, -- identificador unico de la anotacion
    rel_gen VARCHAR(100), -- indica la relacion de la anotacion con el gen 
    tipo_anot VARCHAR(50), -- tipo de anotacion: funcional, clinica, etc.
    descrip_anot VARCHAR(255), -- descripcion de la anotacion
    PRIMARY KEY (Id_anotacion) -- define Id_anotacion  como clave primaria 
	

);

CREATE TABLE ESTUDIO(
	ref_articulo VARCHAR(8) NOT NULL, -- referencia del estudio, por ejemplo: aaaa/111
    titulo VARCHAR(255), -- titulo del estudio
    fecha_publicacion DATE, -- fecha de publicacion del estudio 
    PRIMARY KEY (ref_articulo), -- define la referencia como clave primaria 
    CHECK (ref_articulo REGEXP '^[A-Za-z]{4}/[0-9]{3}$') -- obliga al formato: cuatro letras/ tres numeros 
);


CREATE TABLE ESTUDIO_GEN( -- crea la tabla ESTUDIO_GEN
    ref_articulo VARCHAR(8) NOT NULL, -- referencia del estudio
    nombre_gen VARCHAR(100) NOT NULL, -- gen al que pertecene la secuencia
    PRIMARY KEY (ref_articulo, nombre_gen), -- define ref_articulo y nombre_gen como claves primarias compuestas
    FOREIGN KEY (ref_articulo) REFERENCES ESTUDIO(ref_articulo), -- relaciona la tabla con ESTUDIO
    FOREIGN KEY (nombre_gen) REFERENCES GEN(nombre_gen) -- relaciona la tabla con GEN
);

CREATE TABLE ESTUDIO_VARIANTE( -- crea la tabla ESTUDIO_VARIANTE
    ref_articulo VARCHAR(8) NOT NULL, -- referencia del estudio
    Id_var INT NOT NULL, -- identificador unico de la variante 
    PRIMARY KEY (ref_articulo, Id_var), -- define ref_articulo e Id_var como claves primarias compuestas
    FOREIGN KEY (ref_articulo) REFERENCES ESTUDIO(ref_articulo), -- relaciona la tabla con ESTUDIO
    FOREIGN KEY (Id_var) REFERENCES VARIANTE(Id_var) -- relaciona la tabla con VARIANTE

);

CREATE TABLE GEN_ANOTACION( -- crea la tabla GEN_ANOTACION
    nombre_gen VARCHAR(100) NOT NULL, -- gen al que pertecene la secuencia
    Id_anotacion INT NOT NULL, -- identificador unico de la anotacion
    PRIMARY KEY (nombre_gen, Id_anotacion), -- define ref_articulo e Id_anotacion como claves primarias compuestas
    FOREIGN KEY (nombre_gen) REFERENCES GEN(nombre_gen), -- relaciona la tabla con GEN
    FOREIGN KEY (Id_anotacion) REFERENCES ANOTACION(Id_anotacion) -- relaciona la tabla con ANOTACION

);


-- comparacion final 

SHOW TABLES; -- muestra todas las tablas creadas en la base de datos
DESCRIBE GEN; -- muestra las columnas y caracteristicas de la tabla GEN
DESCRIBE SECUENCIA; -- muestra las columnas y caracteristicas de la tabla SECUENCIA
DESCRIBE VARIANTE; -- muestra las columnas y caracteristicas de la tabla VARIANTE
DESCRIBE ANOTACION; -- muestra las columnas y caracteristicas de la tabla ANOTACION
DESCRIBE ESTUDIO; -- muestra las columnas y caracteristicas de la tabla ESTUDIO
DESCRIBE ESTUDIO_GEN; -- muestra las columnas y claves de ESTUDIO_GEN
DESCRIBE ESTUDIO_VARIANTE; -- muestra las columnas y claves de ESTUDIO_VARIANTE
DESCRIBE GEN_ANOTACION; -- muestra las columnas y claves de GEN_ANOTACION



SHOW CREATE TABLE GEN; -- muestra la definicion SQL completa de GEN
SHOW CREATE TABLE SECUENCIA; -- permite comprobar PK, FK y CHECK de SECUENCIA
SHOW CREATE TABLE VARIANTE; -- permite comprobar PK, FK, DEFAULT y CHECK de VARIANTE
SHOW CREATE TABLE ANOTACION; -- muestra la definicion completa de ANOTACION
SHOW CREATE TABLE ESTUDIO; -- permite comprobar la PK y la restriccion del formato de referencia 
SHOW CREATE TABLE ESTUDIO_GEN; -- comprueba PK y FK de ESTUDIO_GEN
SHOW CREATE TABLE ESTUDIO_VARIANTE; -- comprueba PK y FK de ESTUDIO_VARIANTE
SHOW CREATE TABLE GEN_ANOTACION; -- comprueba PK y FK de GEN_ANOTACION

-- Manipulación y edición de datos en las tablas generadas

INSERT INTO gen -- añado información relativa al gen MAFB a la tabla
(nombre_gen, localizacion_gen, descripcion_gen)
VALUES("MAFB", "20q12", "Factor de transcripción del tipo «leucine zipper» básico (bZIP). La proteína codificada reprime la transcripción, mediada por ETS1, de genes específicos de la línea eritroide.");

UPDATE gen
SET descripcion_gen = "MAF bZIP transcription factor B"
WHERE nombre_gen = "MAFB";

INSERT INTO anotacion -- añado información relativa a la anotación del gen MAFB a la tabla
(Id_anotacion, rel_gen, tipo_anot, descrip_anot)
VALUES(9935, "MAFB", "Functional", "Plays a pivotal role in regulating lineage-specific hematopoiesis by repressing ETS1-mediated transcription of erythroid-specific genes in myeloid cells");

INSERT INTO estudio -- añado información relativa a un estudio sobre MAFB a la tabla
(ref_articulo, titulo, fecha_publicacion)
VALUES("Siew/996", "MafB is an interaction partner and repressor of Ets-1 that inhibits erythroid differentiation", "1996-04-05");

INSERT INTO estudio_gen -- relaciono la referencia del articulo de la tabla estudio con el gen MAFB
(ref_articulo, nombre_gen)
VALUES("Siew/996", "MAFB");

INSERT INTO secuencia -- añado información relativa a la secuencia del gen MAFB a la tabla
(Id_secuencia, nombre_gen, repr_cad_ADN, tipo_sec, pos_rel_gen_sec)
VALUES(005461, "MAFB", "ACAGCTGCACCGCCGAGCTGCGAGCGGCTGCGAGCGAGAGAGCGTAAGAGCAAGAGAGCTAGAGAGCGAGCAACGGGCACTCGCCCCACGCCTCCCCTCAGCCCCACCGCGCGCTCCGCTTGCCTCTCCACCCCGCCCGACTCTACCCGGCCCGGTCCCTGCGCGGGCACAGCCCAGAG", "cDNA", "20");

INSERT INTO variante -- añado información relativa a una variante del gen MAFB a la tabla
(Id_var, Id_secuencia, alelo_ref, alelo_mut, tipo_var, pos_rel_gen_var)
VALUES(807627, 005461, "A", "G", "Patogénica", 184);

INSERT INTO estudio -- añado información relativa a un estudio sobre la variante del gen MAFB descrita en la tabla anterior
(ref_articulo, titulo, fecha_publicacion)
VALUES("Zank/012", "Multicentric carpotarsal osteolysis is caused by mutations clustering in the amino-terminal transcriptional activation domain of MAFB", "2012-03-09");

INSERT INTO estudio_variante -- relaciono la referencia del articulo sobre la variante del gen MAFB con dicha variante
(ref_articulo, Id_var)
VALUES("Zank/012", 807627);

INSERT INTO gen_anotacion -- relaciono el nombre del gen con su referencia de anotación
(nombre_gen, Id_anotacion)
VALUES("MAFB", 9935);

INSERT INTO gen -- añado información relativa al gen PGM1 a la tabla
(nombre_gen, localizacion_gen, descripcion_gen)
VALUES("PGM1", "1p31.3", "Phosphoglucomutase 1");

INSERT INTO anotacion -- añado información relativa a la anotación del gen PGM1 a la tabla
(Id_anotacion, rel_gen, tipo_anot, descrip_anot)
VALUES(36871, "PGM1", "Functional", "Catalyzes the reversible isomerization of alpha-D-glucose 1-phosphate to alpha-D-glucose 6-phosphate");

INSERT INTO estudio -- añado información relativa a un estudio sobre PGM1 a la tabla
(ref_articulo, titulo, fecha_publicacion)
VALUES("Medr/019", "Clinical and molecular diagnosis of non-phosphomannomutase 2 N-linked congenital disorders of glycosylation in Spain", "2019-04-03");

INSERT INTO estudio_gen -- relaciono la referencia del articulo de la tabla estudio con el gen PGM1
(ref_articulo, nombre_gen)
VALUES("Medr/019", "PGM1");

INSERT INTO secuencia -- añado información relativa a la secuencia del gen PGM1 a la tabla
(Id_secuencia, nombre_gen, repr_cad_ADN, tipo_sec, pos_rel_gen_sec)
VALUES(5236, "PGM1", "AGAGCAGCTGCAGCCTCAGCCGGCCGCCCCTCCGCCAGCCAAGTCCGCCGCTCTGACCCCCGGCAGCAAGTCGCCACCATGGTGAAGATCGTGACAGTTAAGACCCAGGCGTACCAGGACCAGAAGCCGGGCACGAGCGG", "DNA", "81");

INSERT INTO variante -- añado información relativa a una variante del gen PGM1 a la tabla
(Id_var, Id_secuencia, alelo_ref, alelo_mut, tipo_var, pos_rel_gen_var)
VALUES(768778, 5236, "G", "A", "Patogénica", 871);

INSERT INTO estudio -- añado información relativa a un estudio sobre la variante del gen PGM1 descrita en la tabla anterior
(ref_articulo, titulo, fecha_publicacion)
VALUES("Pere/013", "PGM1 deficiency causes a non-neurological disorder of glycosylation", "2012-09-14");

INSERT INTO estudio_variante -- relaciono la referencia del articulo sobre la variante del gen PGM1 con dicha variante
(ref_articulo, Id_var)
VALUES("Pere/013", 768778);

INSERT INTO gen_anotacion -- relaciono el nombre del gen con su referencia de anotación
(nombre_gen, Id_anotacion)
VALUES("PGM1", 36871);

INSERT INTO gen -- añado información relativa al gen VMA22 a la tabla
(nombre_gen, localizacion_gen, descripcion_gen)
VALUES("VMA22", "2q21.1", "vacuolar ATPase assembly factor VMA22");

INSERT INTO anotacion -- añado información relativa a la anotación del gen VMA22 a la tabla
(Id_anotacion, rel_gen, tipo_anot, descrip_anot)
VALUES(960, "VMA22", "Clinical", "Congenital disorder of glycosylation, type IIo");

INSERT INTO estudio -- añado información relativa a un estudio sobre VMA22 a la tabla
(ref_articulo, titulo, fecha_publicacion)
VALUES("Pere/017", "A Population-Based Study on Congenital Disorders of Protein N- and Combined with O-Glycosylation Experience in Clinical and Genetic Diagnosis", "2017-01-27");

INSERT INTO estudio_gen -- relaciono la referencia del articulo de la tabla estudio con el gen VMA22
(ref_articulo, nombre_gen)
VALUES("Pere/017", "VMA22");

INSERT INTO secuencia -- añado información relativa a la secuencia del gen VMA22 a la tabla
(Id_secuencia, nombre_gen, repr_cad_ADN, tipo_sec, pos_rel_gen_sec)
VALUES(84317, "VMA22", "MGTPLDGGSRVPIGCPAKLRRVTRKKVAPDLEGWLSLAKARYAMGAKSVGPLQYASHMEPQVCLHASEAQEGLQKFKVVRAGVHAPEEVGPREAGLRRRKGPTKTPEPESSEAPQDPLNWFGILVPHSLRQAQASFRDGLQLAADIASLQNRIDWGRSQLRGLQEKLKQLEPGAA", "Protein", "31");

INSERT INTO variante -- añado información relativa a una variante del gen VMA22 a la tabla
(Id_var, Id_secuencia, alelo_ref, alelo_mut, tipo_var, pos_rel_gen_var)
VALUES(325113, 84317, "T", "C", "Patogénica", 92);

INSERT INTO estudio -- añado información relativa a un estudio sobre la variante del gen VMA22 descrita en la tabla anterior
(ref_articulo, titulo, fecha_publicacion)
VALUES("Jans/016", "CCDC115 Deficiency Causes a Disorder of Golgi Homeostasis with Abnormal Protein Glycosylation", "2016-01-28");

INSERT INTO estudio_variante -- relaciono la referencia del articulo sobre la variante del gen VMA22 con dicha variante
(ref_articulo, Id_var)
VALUES("Jans/016", 325113);

INSERT INTO gen_anotacion -- relaciono el nombre del gen con su referencia de anotación
(nombre_gen, Id_anotacion)
VALUES("VMA22", 960);

-- Muestro los valores añadidos a todas las tablas de la base de datos

SELECT *
FROM anotacion;

SELECT *
FROM estudio;

SELECT *
FROM estudio_gen;

SELECT *
FROM estudio_variante;

SELECT *
FROM gen;

SELECT *
FROM gen_anotacion;

SELECT *
FROM secuencia;

SELECT *
FROM variante;

