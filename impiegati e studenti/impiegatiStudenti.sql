CREATE DATABASE ImpiegatiStudenti;

CREATE TYPE TipoPersona AS ENUM ('Persona', 'Studente', 'Impiegato');

CREATE TYPE Genere AS ENUM ('Uomo', 'Donna');

CREATE TYPE Ruolo AS ENUM ('Segretario', 'Direttore', 'Progettista');

CREATE DOMAIN CodiceFiscale as varchar check (value ~ '^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$');

CREATE DOMAIN IntGEZ as integer check (value >= 0);

CREATE DOMAIN IntGZ as integer check (value > 0);

CREATE DOMAIN RealGEZ as real check (value >= 0);

CREATE TABLE Persona  (
    nome varchar not null,
    cognome varchar not null,
    cf CodiceFiscale primary key,
    nascita date not null,
    tipo TipoPersona not null,
    genere Genere not null,
    maternita IntGEZ,
    pos_militare varchar,
    check (
        (genere = 'Uomo' and pos_militare is not null and maternita is null)
        or
        (genere = 'Donna' and maternita is not null and pos_militare is null)
    )
);

CREATE TABLE Impiegato (
    stipendio RealGEZ not null,
    ruolo Ruolo not null,
    cf CodiceFiscale primary key,
    foreign key (cf) references Persona(cf),
);

CREATE TABLE Studente (
    cf CodiceFiscale primary key,
    matricola IntGZ unique not null,
    foreign key (cf) references Persona(cf)
);

CREATE TABLE Progetto (
    nome varchar not null,
    id IntGZ primary key
);

CREATE TABLE Responsabile(
    cf CodiceFiscale primary key,
    foreign key (cf) references Impiegato(cf)
);

CREATE TABLE respProg (
    cf CodiceFiscale not null,
    progetto integer not null,
    primary key (cf, progetto),
    foreign key (cf) references Responsabile(cf),
    foreign key (progetto) references Progetto(id),
);

INSERT INTO persona (nome, cognome, cf, nascita, tipo, genere, maternita) 
VALUES 
('Alice', 'Alici', 'AAAAAA00A00A000A', '07/27/1995','Impiegato', 'Donna', 3), 
('Daniela', 'Danieli', 'DDDDDD00D00D000D', '10/27/1995', 'Impiegato', 'Donna', 7);

INSERT INTO persona (nome, cognome, cf, nascita, tipo, genere, pos_militare) 
VALUES 
('Bruno', 'Bruni', 'BBBBBB00B00B000B', '08/27/1995', 'Impiegato', 'Uomo', 'Civile'),
('Carlo', 'Carli', 'CCCCCC00C00C000C', '09/27/1995', 'Studente', 'Uomo', 'Tenente');

INSERT INTO impiegato (stipendio, ruolo, cf)
VALUES
(1500, 'Direttore', 'AAAAAA00A00A000A'),
(2000, 'Progettista', 'BBBBBB00B00B000B'),
(8888, 'Progettista', 'DDDDDD00D00D000D');

INSERT INTO Responsabile (cf)
VALUES
('DDDDDD00D00D000D');

INSERT INTO studente (cf, matricola)
VALUES
('CCCCCC00C00C000C', 1);

INSERT INTO progetto (nome, id)
VALUES
("Progettone", 1),
("Progettino", 2);

INSERT INTO respProg (cf, progetto)
VALUES
('DDDDDD00D00D000D', 1),
('DDDDDD00D00D000D', 2);