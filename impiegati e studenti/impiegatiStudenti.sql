CREATE TYPE TipoPersona AS ENUM ('Persona', 'Studente', 'Impiegato');

CREATE TYPE Genere AS ENUM ('Uomo', 'Donna');

CREATE TYPE Ruolo AS ENUM ('Segretario', 'Direttore', 'Progettista');

CREATE DOMAIN CodiceFiscale as Stringa check (value ~ '^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$');

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
        genere = 'Uomo' and pos_militare is not null and maternita is null
        or
        genere = 'Donna' and maternita is not null and pos_militare is null
    )
);

CREATE TABLE Impiegato (
    stipendio RealGEZ not null,
    ruolo Ruolo not null,
    is_responsabile boolean not null,
    cf CodiceFiscale primary key,
    foreign key (cf) references Persona(cf)
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
    foreign key (progetto) references Progetto(id)
);