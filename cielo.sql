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

insert into Compagnia(nome, annoFondaz) values
('Compagnia_Uno', null),
('Compagnia_Due', 2020),
('Compagnia_Tre', null);


create table Aeroporto(
    codice codIATA not null,
    nome stringaM not null,
    primary key(codice)
    --foreign key(codice) references LuogoAeroporto(aeroporto) DEFERRABLE INITIALLY DEFERRED	
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

begin transaction;
set constraints all deferred;
insert into Aeroporto(codice, nome) values
('AAA', 'Fiumicino'),
('BBB', 'Ciampino');
insert into LuogoAeroporto(aeroporto, citta, nazione) values
('AAA', 'Roma', 'Italia'),
('BBB', 'Roma', 'Italia');
commit work;

create table Volo(
    codice PosInteger not null,
    comp StringaM not null, 
    durataMinuti PosInteger not null,
    primary key(codice, comp),
    foreign key (comp) references Compagnia(nome)
    --foreign key (codice, comp) references ArrPart(Codice, comp) deferrable
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

begin transaction;
set constraints all deferred;
insert into Volo(codice, comp, durataMinuti) values
('1', 'Compagnia_Uno', 5),
('2', 'Compagnia_Due', 5);
insert into ArrPart(codice, comp, arrivo, partenza) values
('1', 'Compagnia_Uno', 'AAA', 'BBB'),
('2', 'Compagnia_Due', 'BBB', 'AAA');
commit work;

select * from Compagnia;
select * from Aeroporto;
select * from LuogoAeroporto;
select * from Volo;
<<<<<<< HEAD
select * from ArrPart;
=======
select * from ArrPart;
>>>>>>> 8997f8bd9ef808c9c2d503fb8de6d184d355bbaf
