create database Azienda;


create domain RealGEZ as real
    check (value >= 0);


create domain Stringa as varchar;


create type Indirizzo as(
    via Stringa,
    civico Stringa
);


create table Progetto(
    id integer primary key,
    nome Stringa not null,
    budget RealGEZ not null
);


create table Impiegato(
    id integer primary key,
    nome Stringa not null,
    cognome Stringa not null,
    nascita date not null,
    stipendio RealGEZ not null
);


create table Dipartimento(
    id integer primary key,
    nome Stringa not null,
    indirizzo Indirizzo
);


create table NumeroTelefono(
    telefono Stringa primary key
);


create table Coinvolto(
    impiegato integer not null,
    progetto integer not null,
    foreign key (impiegato) references Impiegato(id),
    foreign key (progetto) references Progetto(id),
    primary key (impiegato, progetto)
);


create table Direzione(
    impiegato integer not null,
    dipartimento integer not null,
    foreign key (impiegato) references Impiegato(id),
    foreign key (dipartimento) references Dipartimento(id),
    primary key (dipartimento)
);


create table Afferenza(
    impiegato integer not null,
    dipartimento integer not null,
    data_afferenza date not null,
    foreign key (impiegato) references Impiegato(id),
    foreign key (dipartimento) references Dipartimento(id),
    primary key (impiegato)
);


create table Dip_Num_Tel(
    dipartimento integer not null,
    telefono Stringa not null,
    foreign key (dipartimento) references Dipartimento(id),
    foreign key (telefono) references NumeroTelefono(telefono),
    primary key (dipartimento, telefono)
);