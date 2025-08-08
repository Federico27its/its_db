create database OrdiniEFatture;

create domain Stringa as varchar;

create domain IntGEZ as integer check (value>=0);

create domain RealGEZ as real check (value>=0);

create type Indirizzo as(
via Stringa,
civico Stringa
CAP Stringa check (value ~ '\d{5}'));

create domain CodiceFiscale as char(16) check (value ~ '[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]');

create domain Telefono as varchar(15);

create domain Email as Stringa check (value ~ '^[A-Z0-9._%+-]++@(?:[A-Z0-9]++\.)++[A-Z]{2,}+$)';

create domain PartitaIva as char(11) check (value ~ '\d{11}');

create domain RealZO as real
check (value >= 0 and  value =< 1);

create type StatoOrdineEnum as enum(
    'In Preparazione', 'Inviato', 'Da Saldare', 'Saldato'
);
