create table programa (
	id int primary key,
	nombre text,
	meta int,
	presupuesto int,
	fecha_inicio date,
	fecha_final date
);

create table subprograma (
	id int primary key,
	nombre text,
	programa int references programa(id)
);

create table provincia (
	codigo smallint primary key,
	nombre varchar(15) not null
);

create table municipio (
	codigo smallint primary key,
	provinc smallint references provincia(codigo),
	nombre varchar (50) not null,
	poblacion int not null
);

create table barrio_vereda (
	codigo smallint primary key,
	nombre varchar(40),
	municip smallint references municipio(codigo)
);

create table equipo (
	codigo smallint primary key,
	provincia smallint not null references provincia(codigo),
	líder varchar(50) not null,
	num_integrantes smallint
);

create table funcionario (
	identificacion varchar(12) primary key,
	nombre varchar(50) not null,
	telefono varchar(10),
	equipo smallint references equipo(codigo),
	rol varchar(10)
);

create table avances (
	codigo smallint unique,
	subprog int REFERENCES subprograma(id),
	tipo char(2) not null check(tipo in ('ev', 'pc')),
	equip smallint references equipo(codigo),
	zona smallint references barrio_vereda(codigo),
	nombre varchar(50),
	deporte varchar(30),
	mes varchar(15),
	duracion_sesiones smallint,
	cantidad_sesiones_mes smallint,
	primary key(codigo, subprog, tipo, equip, zona)
);

create table beneficiados(
	avance smallint references avances(codigo),
	edad smallint not null,
	genero char check (genero in ('m','f')),
	poblacion varchar(10) check(poblacion in ('mestizos','indig','campes','disc','afro')),
	num_victimas smallint,
	cantidad_personas int,
	primary key(avance, edad, genero)
);

