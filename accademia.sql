create database Accademia;


create type Strutturato as
    enum ('Ricercatore', 'Professore Associato', 'Professore Ordinario');

create type LavoroProgetto as
    enum ('Ricerca e Sviluppo', 'Dimostrazione', 'Management', 'Altro');

create type LavoroNonProgettuale as
    enum ('Didattica', 'Ricerca', 'Missione', 'Incontro Dipartimentale', 'Incontro Accademico', 'Altro');

create type CausaAssenza as
    enum ('Chiusura Universitaria', 'Maternita', 'Malattia');

create domain PosInteger as integer
    check (value >= 0);

create domain StringaM as varchar(100);

create domain NumeroOre as integer
    check (value >= 0 and value <= 8);

create domain Denaro as real
    check (value >= 0);

create table Persona (
    id PosInteger not null,
    nome StringaM not null,
    cognome StringaM not null,
    posizione Strutturato not null,
    stipendio Denaro not null,
    primary key(id)
);

insert into Persona(id, nome, cognome, posizione, stipendio) values
(1, 'Alice', 'Alici', 'Ricercatore', 24000),
(2, 'Bruno', 'Bianchi', 'Professore Ordinario', 2),
(3, 'Carlo', 'Carli', 'Ricercatore', 999),
(4, 'Valerio', 'Valeri', 'Professore Associato', 100000000),
(5, 'Bob', 'Bianchi', 'Ricercatore', 1),
(6, 'Vov', 'Verdi', 'Professore Ordinario', 518);



create table Progetto(
    id PosInteger not null,
    nome StringaM not null,
    inizio date not null,
    fine date not null,
    budget Denaro not null,
    primary key(id),
    unique(nome),
    check (inizio < fine)
);

insert into Progetto(id, nome, inizio, fine, budget) values
(1, 'Progettone', '12-01-1994', '10-05-2012', 3),
(2, 'Progettino', '12-02-1995', '10-02-1996', 50000000),
(3, 'Progetto', '12-01-1994', '10-05-2112', 333);


create table WP(
    progetto PosInteger not null,
    id PosInteger not null,
    nome StringaM not null,
    inizio date not null,
    fine date not null,
    primary key(progetto, id),
    check (inizio < fine),
    unique(progetto, nome),
    foreign key(progetto) references Progetto(id)
);

insert into WP(progetto, id, nome, inizio, fine) values
(1, 1, 'NonSaprei', '12-01-1994', '10-05-2012'),
(2, 1, 'NonLoSo', '12-02-1995', '10-02-1997');

create table AttivitaProgetto(
    id PosInteger not null,
    persona PosInteger not null,
    progetto PosInteger not null,
    wp PosInteger not null,
    giorno date not null,
    tipo LavoroProgetto not null,
    oreDurata NumeroOre not null,
    primary key(id),
    foreign key(persona) references Persona(id),
    foreign key(progetto, wp) references WP(progetto, id)
);

insert into AttivitaProgetto(id, persona, progetto, wp, giorno, tipo, oreDurata) values
(1, 1, 1, 1, '06-18-1989', 'Dimostrazione', 5),
(2, 2, 2, 1, '12-01-1995', 'Altro', 6),
(3, 2, 2, 1, '12-02-1995', 'Altro', 6);

create table AttivitaNonProgettuale(
    id PosInteger not null,
    persona PosInteger not null,
    tipo LavoroNonProgettuale not null,
    giorno date,
    oreDurata NumeroOre not null,
    primary key(id),
    foreign key(persona) references Persona(id)
);

insert into AttivitaNonProgettuale(id, persona, tipo, giorno, oreDurata) values
(1, 1, 'Didattica', '12-05-2023', '8'),
(2, 2, 'Missione', '11-20-2000', '3'),
(3, 2, 'Didattica', '12-05-2023', '8'),
(4, 1, 'Didattica', '12-06-2023', '8');

create table Assenza(
    id PosInteger not null,
    persona PosInteger not null,
    tipo CausaAssenza not null,
    giorno date not null,
    primary key(id),
    unique(persona, giorno),
    foreign key(persona) references Persona(id)
);

insert into Assenza(id, persona, tipo, giorno) values
(1, 1, 'Maternita', '10-23-2012'),
(2, 2, 'Malattia', '01-01-2001'),
(3, 2, 'Maternita', '03-26-2001');

select distinct cognome from Persona;

select nome, cognome from Persona 
where Persona.posizione = 'Ricercatore';

select * from Persona
where Persona.posizione = 'Professore Associato' and cognome like 'V%';

select * from Persona
where (Persona.posizione = 'Professore Associato' or Persona.posizione = 'Professore Ordinario') and cognome like 'V%';

select * from Progetto
where Progetto.fine<current_date;

select nome from Progetto
order by inizio;

select nome from WP
order by nome;

select distinct tipo from Assenza;

select distinct tipo from AttivitaProgetto;

select distinct giorno from AttivitaNonProgettuale
<<<<<<< HEAD
where AttivitaNonProgettuale.tipo = 'Didattica';
=======
where AttivitaNonProgettuale.tipo = 'Didattica';
>>>>>>> 8997f8bd9ef808c9c2d503fb8de6d184d355bbaf
