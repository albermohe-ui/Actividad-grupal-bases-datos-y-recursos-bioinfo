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
    FOREIGN KEY (nombre_gen) REFERENCES GEN(nombre_gen), -- relaciona la secuncia con GEN
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
VALUES(9935, "MAFB", "GCF_000001405.40-RS_2025_08", "Factor de transcripción del tipo «leucine zipper» básico (bZIP). La proteína codificada reprime la transcripción, mediada por ETS1, de genes específicos de la línea eritroide.");

INSERT INTO estudio -- añado información relativa a un estudio sobre MAFB a la tabla
(ref_articulo, titulo, fecha_publicacion)
VALUES("Siew/996", "MafB is an interaction partner and repressor of Ets-1 that inhibits erythroid differentiation", "1996-04-05");

INSERT INTO estudio_gen -- relaciono la referencia del articulo de la tabla estudio con el gen MAFB
(ref_articulo, nombre_gen)
VALUES("Siew/996", "MAFB");

INSERT INTO secuencia -- añado información relativa a la secuencia del gen MAFB a la tabla
(Id_secuencia, nombre_gen, repr_cad_ADN, tipo_sec, pos_rel_gen_sec)
VALUES(005461, "MAFB", "1 acagctgcac cgccgagctg cgagcggctg cgagcgagag agcgtaagag caagagagct 61 agagagcgag caacgggcac tcgccccacg cctcccctca gccccaccgc gcgctccgct 121 tgcctctcca ccccgcccga ctctacccgg cccggtccct gcgcgggcac agcccagagc
 181 tctggggcgg tgcaggcagc ctcgggactc tccggcgcgc cgccgcgtcc ccagacaaag 241 gcttggccgg cggccccggc ccgctgcgcc ctcgctcccc gcctccccag ctcttctccg 301 ctcttccccc ccgcgcttgg ctcggcgcgc tccggccggc cgcaaagttt cccgggcggc 
 361 agcggcggct gcgcctcgct tcagcgatgg ccgcggagct gagcatgggg ccagagctgc 421 ccaccagccc gctggccatg gagtatgtca acgacttcga cctgctcaag ttcgacgtga 481 agaaggagcc actggggcgc gcggagcgtc cgggcaggcc ctgcacacgc ctgcagccag", "mRNA", "20");

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

