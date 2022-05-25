--inserciones

insert into programa(id, nombre, meta, presupuesto, fecha_inicio, fecha_final)
values (1, 'CREEMOS FOMENTO Y PROMOCIÓN DEL DEPORTE, ACTIVIDAD FÍSICA Y RECREACIÓN PARA LA CONSTRUCCIÓN DE LA PAZ',15000,500000000,'2022-01-30','2022-07-12'),
(2, 'CREEMOS EN BOYACA RAZA DE CAMPEONES',20000,200000000,'2022-03-03','2022-11-24'),
(3, 'GESTIÓN DEL CONOCIMIENTO',8500,77000000,'2022-03-03','2022-11-24');

insert into subprograma(id, nombre,programa)
values (11, 'CREEMOS LOGROS DEPORTIVOS PARA BOYACÁ', 1),
(12, 'CREEMOS DEPORTE SOCIAL COMUNITARIO CON INCLUSIÓN POR LA PAZ', 1),
(13, 'CREEMOS EN BOYACÁ MAS ACTIVA - H.E.V.S', 1),
(14, 'CREEMOS EN CIENCIAS APLICADAS AL DEPORTE', 1),
(21, 'CREEMOS EN FORMACIÓN Y HÁBITOS DEPORTIVOS', 2),
(22, 'CREEMOS JÓVENES POR BOYACÁ', 2),
(23, 'CREEMOS VIDA SALUDABLE POR EL RESPETO DE LA PERSONA MAYOR', 2),
(24, 'JUEGOS SUPÉRATE INTERCOLEGIADOS POR LA PAZ', 2),
(31, 'RE-CREEMOS EN BOYACÁ', 3),
(32, 'CREEMOS EN EL DESARROLLO DEL CICLISMO COMO DEPORTE INSIGNIA DEL DPTO - PDDC', 3),
(33, 'CREEMOS CENTROS DE ESTUDIOS E INVESTIGACIÓN PARA EL ALTO RENDIMIENTO DEPORTIVO', 3);

copy provincia from 'C:/psg/provincias.csv' delimiter ';' csv header;
copy municipio from 'C:/psg/municipios.csv' delimiter ';' csv header;
copy barrio_vereda from 'C:/psg/barrio_vereda.csv' delimiter ';' csv header;
copy equipo from 'C:/psg/equipos.csv' delimiter ';' csv header;
copy funcionario from 'C:/psg/funcionarios.csv' delimiter ';' csv header;
copy avances from 'C:/psg/avances.csv' delimiter ';' csv header;
copy beneficiados from 'C:/psg/beneficiados.csv' delimiter ';' csv header;

--roles
create role gerente;
grant select, insert, delete, update on all tables 
to gerente;

create role lider_equipo;
grant select, insert, update on avances, beneficiados
to lider_equipo;

--consultas
--beneficiadios por condicion, programa
select poblacion, sum(cantidad_personas)
from beneficiados
group by poblacion;

--mes
select a.mes, sum(b.cantidad_personas)
from beneficiados b natural join avances a
group by mes;

--por edad

SELECT genero, sum(cantidad_personas),
       CASE
           WHEN edad> 0
                AND edad <= 5 THEN '0-5 años'
           WHEN edad > 5
                AND edad <= 12 THEN '6-12 años'
		   WHEN edad > 12
                AND edad <= 17 THEN '12-17 años'
		   WHEN edad > 17
                AND edad <= 29 THEN '18-29 años'
		   WHEN edad > 29
                AND edad <= 59 THEN '30-59 años'
           WHEN edad> 60 THEN 'mayor de 60 años'
       END rango
FROM beneficiados
GROUP BY rango, genero;

--provincias impactadas
select distinct a.subprog, p.nombre
from avances a, provincia p, barrio_vereda b, municipio m
where a.zona = b.codigo and b.municip = m.codigo and m.provinc = p.codigo

--municipios impactados
select distinct a.subprog, m.nombre
from avances a, barrio_vereda b, municipio m
where a.zona = b.codigo and b.municip = m.codigo

--triggers
create table avances_updates_log (
  usuario varchar(40),
  update_time timestamp with time zone,
  update_log avances
);

create or replace function log_avances_update()
  returns trigger 
  language 'plpgsql'
as $$
BEGIN
  if new <> old THEN
    insert into avances_updates_log(usuario, update_time, update_log) values (current_user, now(), new);
  end if;
  return new;
end;
$$;

create trigger avances_updates
after update on avances
for each row
execute procedure log_avances_update();

