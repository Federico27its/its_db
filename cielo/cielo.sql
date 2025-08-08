create database Cielo;

create domain PosInteger as Integer
    check (value >= 0);

create domain StringaM as varchar(100);

create domain CodIATA as char(3);

create table Compagnia(
    nome StringaM not null,
    annoFondaz PosInteger,
    primary key(nome)
);

/*
insert into Compagnia(nome, annoFondaz) values
('Compagnia_Uno', null),
('Compagnia_Due', 2020),
('Compagnia_Tre', null);
*/

create table Aeroporto(
    codice codIATA not null,
    nome stringaM not null,
    primary key(codice)
    -- foreign key(codice) references LuogoAeroporto(aeroporto) DEFERRABLE INITIALLY DEFERRED	
);


create table LuogoAeroporto(
    aeroporto codIATA not null,
    citta stringaM not null,
    nazione stringaM not null,
    primary key(aeroporto),
    foreign key (aeroporto) references Aeroporto(codice) deferrable
);

alter table Aeroporto
add foreign key(codice) references LuogoAeroporto(aeroporto) deferrable;

/*
begin transaction;
set constraints all deferred;
insert into Aeroporto(codice, nome) values
('AAA', 'Fiumicino'),
('BBB', 'Ciampino');
insert into LuogoAeroporto(aeroporto, citta, nazione) values
('AAA', 'Roma', 'Italia'),
('BBB', 'Roma', 'Italia');
commit work;
*/

create table Volo(
    codice PosInteger not null,
    comp StringaM not null, 
    durataMinuti PosInteger not null,
    primary key(codice, comp),
    foreign key (comp) references Compagnia(nome)
    -- foreign key (codice, comp) references ArrPart(Codice, comp) deferrable
);


create table ArrPart(
    codice PosInteger not null,
    comp stringaM not null,
    arrivo codIATA not null,
    partenza codIATA not null,
    primary key(codice, comp),
    foreign key (codice, comp) references Volo(codice, comp) deferrable,
    foreign key (arrivo) references Aeroporto(codice),
    foreign key (partenza) references Aeroporto(codice)
);

alter table Volo
add foreign key (codice, comp) references ArrPart(Codice, comp) deferrable;

/*
begin transaction;
set constraints all deferred;
insert into Volo(codice, comp, durataMinuti) values
('1', 'Compagnia_Uno', 5),
('2', 'Compagnia_Due', 5);
insert into ArrPart(codice, comp, arrivo, partenza) values
('1', 'Compagnia_Uno', 'AAA', 'BBB'),
('2', 'Compagnia_Due', 'BBB', 'AAA');
commit work;
*/

/* 1. Quali sono i voli (codice e nome della compagnia) la cui durata 
supera le 3 ore? */

select v.codice, v.comp
from volo v
where v.durataminuti > 180;

/* 2. Quali sono le compagnie che hanno voli che superano le 3 ore? */

select distinct v.comp
from volo v
where v.durataminuti > 180;

/* 3. Quali sono i voli (codice e nome della compagnia) che partono 
dall’aeroporto con codice ‘CIA’? */

select distinct v.codice, v.comp
from volo v, arrpart a
where a.partenza = 'CIA' and v.codice = a.codice;

/* 4. Quali sono le compagnie che hanno voli che arrivano 
all’aeroporto con codice ‘FCO’? */

select distinct c.nome
from arrpart a, compagnia c
where a.arrivo = 'FCO' and a.comp = c.nome;

/* 5. Quali sono i voli (codice e nome della compagnia)
che partono dall’aeroporto ‘FCO’ e arrivano all’aeroporto ‘JFK’? */

select v.codice, v.comp
from volo v, arrpart a
where a.partenza = 'FCO' and a.arrivo = 'JFK' and v.codice = a.codice;

/* 6. Quali sono le compagnie che hanno voli che partono
dall’aeroporto ‘FCO’ e atterrano all’aeroporto ‘JFK’? */

select distinct c.nome
from compagnia c, arrpart a
where c.nome = a.comp and a.partenza = 'FCO' and a.arrivo = 'JFK';

/* 7. Quali sono i nomi delle compagnie che hanno voli diretti
dalla città di ‘Roma’ alla città di ‘New York’? */

select distinct c.nome
from compagnia c, arrpart a, luogoaeroporto l, luogoaeroporto l1
where l.citta = 'Roma' and
l1.citta = 'New York' and c.nome = a.comp and ((a.partenza = l.aeroporto and a.arrivo = l1.aeroporto)
                                               or (a.arrivo = l.aeroporto and a.partenza = l1.aeroporto));

/* 8. Quali sono gli aeroporti (con codice IATA, nome e luogo)
nei quali partono voli della compagnia di nome ‘MagicFly’? */

select distinct a.codice, a.nome, l.citta
from volo v, aeroporto a, luogoaeroporto l, arrpart arr
where arr.comp = 'MagicFly' and a.codice = arr.partenza and l.aeroporto = arr.partenza;

/* 9. Quali sono i voli che partono da un qualunque aeroporto della città di
‘Roma’ e atterrano ad un qualunque aeroporto della città di ‘New York’?
Restituire: codice del volo, nome della compagnia, e aeroporti di partenza e arrivo. */

select arr.codice, arr.comp, arr.partenza, arr.arrivo
from arrpart arr, luogoaeroporto l, luogoaeroporto l1
where l.citta = 'Roma' and l.aeroporto = arr.partenza and
l1.citta = 'New York' and arr.arrivo = l1.aeroporto;

/* 10. Quali sono i possibili piani di volo con esattamente un cambio
(utilizzando solo voli della stessa compagnia) da un qualunque aeroporto 
della città di ‘Roma’ ad un qualunque aeroporto della città di ‘New York’? 
Restituire: nome della compagnia, codici dei voli, e aeroporti di partenza,
scalo e arrivo. */

select distinct arr.comp, arr.codice, arr.partenza, arr1.partenza as scalo, arr1.codice, arr1.arrivo
from arrpart arr, arrpart arr1, luogoaeroporto l, luogoaeroporto l1
where l.citta = 'Roma' and l.aeroporto = arr.partenza and
l1.citta = 'New York' and arr1.arrivo = l1.aeroporto and
arr.arrivo = arr1.partenza and arr.comp = arr1.comp;

/* 11. Quali sono le compagnie che hanno voli che partono dall’aeroporto ‘FCO’,
atterrano all’aeroporto ‘JFK’, e di cui si conosce l’anno di fondazione? */

select c.nome
from arrpart arr, compagnia c
where arr.partenza = 'FCO' and arr.arrivo = 'JFK' and 
arr.comp = c.nome and c.annofondaz is not null;  
