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

/*
insert into Persona(id, nome, cognome, posizione, stipendio) values
(1, 'Alice', 'Alici', 'Ricercatore', 24000),
(2, 'Bruno', 'Bianchi', 'Professore Ordinario', 2),
(3, 'Carlo', 'Carli', 'Ricercatore', 999),
(4, 'Valerio', 'Valeri', 'Professore Associato', 100000000),
(5, 'Bob', 'Bianchi', 'Ricercatore', 1),
(6, 'Vov', 'Verdi', 'Professore Ordinario', 518);
*/


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

/*
insert into Progetto(id, nome, inizio, fine, budget) values
(1, 'Progettone', '12-01-1994', '10-05-2012', 3),
(2, 'Progettino', '12-02-1995', '10-02-1996', 50000000),
(3, 'Progetto', '12-01-1994', '10-05-2112', 333);
*/


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

/*
insert into WP(progetto, id, nome, inizio, fine) values
(1, 1, 'NonSaprei', '12-01-1994', '10-05-2012'),
(2, 1, 'NonLoSo', '12-02-1995', '10-02-1997');
*/


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

/*
insert into AttivitaProgetto(id, persona, progetto, wp, giorno, tipo, oreDurata) values
(1, 1, 1, 1, '06-18-1989', 'Dimostrazione', 5),
(2, 2, 2, 1, '12-01-1995', 'Altro', 6),
(3, 2, 2, 1, '12-02-1995', 'Altro', 6);
*/


create table AttivitaNonProgettuale(
    id PosInteger not null,
    persona PosInteger not null,
    tipo LavoroNonProgettuale not null,
    giorno date,
    oreDurata NumeroOre not null,
    primary key(id),
    foreign key(persona) references Persona(id)
);

/*
insert into AttivitaNonProgettuale(id, persona, tipo, giorno, oreDurata) values
(1, 1, 'Didattica', '12-05-2023', '8'),
(2, 2, 'Missione', '11-20-2000', '3'),
(3, 2, 'Didattica', '12-05-2023', '8'),
(4, 1, 'Didattica', '12-06-2023', '8');
*/


create table Assenza(
    id PosInteger not null,
    persona PosInteger not null,
    tipo CausaAssenza not null,
    giorno date not null,
    primary key(id),
    unique(persona, giorno),
    foreign key(persona) references Persona(id)
);

/*
insert into Assenza(id, persona, tipo, giorno) values
(1, 1, 'Maternita', '10-23-2012'),
(2, 2, 'Malattia', '01-01-2001'),
(3, 2, 'Maternita', '03-26-2001');
*/



/*
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
where AttivitaNonProgettuale.tipo = 'Didattica';
*/


/*
1. Quali sono il nome, la data di inizio e la data di fine dei WP del progetto di nome
‘Pegasus’?
*/

select nome, inizio, fine
from wp
where wp.progetto='Pegasus'

select wp.nome, wp.inizio, wp.fine
from wp, progetto
where wp.progetto = progetto.id and progetto.nome = 'Pegasus';

/*
2. Quali sono il nome, il cognome e la posizione degli strutturati che hanno almeno
una attività nel progetto ‘Pegasus’, ordinati per cognome decrescente?
*/

select distinct persona.nome, persona.cognome, persona.posizione
from persona, attivitaprogetto, progetto
where persona.id = attivitaprogetto.persona and 
attivitaprogetto.progetto = progetto.id and 
progetto.nome = 'Pegasus'
order by cognome desc;

/*
3. Quali sono il nome, il cognome e la posizione degli strutturati che hanno più di
una attività nel progetto ‘Pegasus*/

select persona.nome, persona.cognome, persona.posizione
from persona, attivitaprogetto, progetto
where persona.id = attivitaprogetto.persona and 
attivitaprogetto.progetto = progetto.id and 
progetto.nome = 'Pegasus'
group by persona.nome, persona.cognome, persona.posizione
having count(*) > 1;          

/*
4. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
fatto almeno una assenza per malattia?
*/

select distinct persona.nome, persona.cognome, persona.posizione
from persona, assenza
where persona.posizione = 'Professore Ordinario' and
persona.id = assenza.persona and
assenza.tipo = 'Malattia';

/*
5. Quali sono il nome, il cognome e la posizione dei Professori Ordinari che hanno
fatto più di una assenza per malattia?
*/

select p.nome, p.cognome, p.posizione
from persona p, assenza a
where p.posizione = 'Professore Ordinario' and
p.id = a.persona and
a.tipo = 'Malattia'
group by p.nome, p.cognome, p.posizione
having count(*) > 1;
/*
6. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno almeno
un impegno per didattica?
*/

select distinct p.nome, p.cognome, p.posizione
from persona p, attivitanonprogettuale a
where a.tipo = 'Didattica' and 
a.persona = p.id and
p.posizione = 'Ricercatore';

/*
7. Quali sono il nome, il cognome e la posizione dei Ricercatori che hanno più di un
impegno per didattica?
*/

select p.nome, p.cognome, p.posizione
from persona p, attivitanonprogettuale a
where a.tipo = 'Didattica' and 
a.persona = p.id and
p.posizione = 'Ricercatore'
group by p.nome, p.cognome, p.posizione
having count(*) > 1;

/*
8. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali?
*/

select p.nome, p.cognome
from persona p, attivitaprogetto ap, attivitanonprogettuale anp
where p.id = ap.persona and
p.id = anp.persona and 
ap.giorno = anp.giorno;

/*
9. Quali sono il nome e il cognome degli strutturati che nello stesso giorno hanno sia
attività progettuali che attività non progettuali? Si richiede anche di proiettare il
giorno, il nome del progetto, il tipo di attività non progettuali e la durata in ore di
entrambe le attività.
*/

select p.nome, p.cognome, ap.giorno, progetto.nome as progetto, ap.oredurata, anp.tipo, anp.oredurata
from persona p, attivitaprogetto ap, attivitanonprogettuale anp, progetto
where p.id = ap.persona and
p.id = anp.persona and 
ap.giorno = anp.giorno
and ap.progetto = progetto.id;



/*
10. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali?
*/

select p.nome, p.cognome
from persona p, attivitaprogetto ap, assenza a
where ap.persona = p.id and
a.persona = p.id and 
a.giorno = ap.giorno;

/*
11. Quali sono il nome e il cognome degli strutturati che nello stesso giorno sono
assenti e hanno attività progettuali? Si richiede anche di proiettare il giorno, il
nome del progetto, la causa di assenza e la durata in ore della attività progettuale.
*/

select p.nome, p.cognome, a.giorno, a.tipo, progetto.nome, ap.oredurata
from persona p, attivitaprogetto ap, assenza a, progetto
where ap.persona = p.id and
a.persona = p.id and 
a.giorno = ap.giorno
and ap.progetto = progetto.id;

/*
12. Quali sono i WP che hanno lo stesso nome, ma appartengono a progetti diversi?
*/
select distinct wp.nome
from wp, wp as wp1
where wp.nome = wp1.nome and 
wp.progetto <> wp1.progetto