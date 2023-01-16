-- 4)Implementa?i în Oracle diagrama conceptual? realizat?: defini?i toate tabelele, 
-- implementând toate constrângerile de integritate necesare (chei primare, cheile externe etc). 

--entitatea PARTENER
create table PARTENER(
    id_part number(4) constraint pk_part primary key,
    nume_partener varchar2(30) constraint null_nume_partener not null,
    nume_contact varchar2(25) constraint null_nume_contact not null,
    email_contact varchar2(30) constraint null_email not null constraint unq_mail unique,
    nr_tel_contact varchar2(15) constraint unq_tel unique,
    oras_sediu varchar2(25)
);

--entitatea SERVICIU
create table SERVICIU(
    id_serviciu number(4) constraint pk_serv primary key,
    nume_serviciu varchar2(60) constraint null_serv not null,
    tip_serviciu varchar2(15) constraint null_tip not null constraint check_tip check(lower(tip_serviciu) in ('donatie','achizitionare','vanzare'))
);

--entitatea GRADINA_ZOOLOGICA
create table GRADINA_ZOOLOGICA(
    id_zoo number(4) constraint pk_zoo primary key,
    locatie varchar2(30) constraint null_locatie not null,
    dimensiune number(4)
);

--entitatea BENEFICIAZA
create table BENEFICIAZA(
    id_part number(4) constraint fk_part references PARTENER(id_part) on delete cascade,
    id_zoo number(4) constraint fk_zoo references GRADINA_ZOOLOGICA(id_zoo) on delete cascade,
    id_serviciu number(4) constraint fk_serv references SERVICIU(id_serviciu) on delete cascade,
    data_serviciu date default sysdate,
    cantitate varchar2(30) constraint null_cantitate not null,
    constraint pk_part_zoo_serv_data primary key(id_part,id_zoo,id_serviciu,data_serviciu)
);

--entitatea PRODUSE
create table PRODUSE(
    id_produs number(4) constraint pk_produs primary key,
    nume_produs varchar2(30) constraint null_nume not null,
    cerinta_produs varchar2(30),
    valabilitate_zile number(4) constraint null_valabilitate not null constraint check_valabilitate check(valabilitate_zile>0)
);

--entitatea VAND
create table VAND(
    id_zoo number(4) constraint fk_zoo_vand references GRADINA_ZOOLOGICA(id_zoo) on delete cascade,
    id_produs number(4) constraint fk_produs references PRODUSE(id_produs) on delete cascade,
    cost number(4) constraint null_cost not null constraint check_cost check(cost>0),
    constraint pk_zoo_produs primary key(id_zoo,id_produs)
);

--entitatea JOBS
create table JOBS(
    id_job varchar2(20) constraint pk_job primary key,
    titlu_job varchar2(35) constraint null_titlu not null,
    salariu_min number(8) constraint null_sal_min not null constraint check_sal_min check(salariu_min>0),
    salariu_max number(8) constraint null_sal_max not null,
    constraint check_sal_max check(salariu_max>salariu_min)
);

--entitatea ANGAJATI
create table ANGAJATI(
    id_ang number(4) constraint pk_angajati primary key,
    nume varchar2(30) constraint null_nume_ang not null,
    prenume varchar2(30),
    salariu number(8) constraint null_salariu_ang not null constraint check_salariu_ang check(salariu>0),
    id_zoo number(4) constraint null_zoo_ang not null constraint fk_zoo_ang references GRADINA_ZOOLOGICA(id_zoo) on delete cascade,
    id_job varchar2(20) constraint null_job_ang not null constraint fk_job_ang references JOBS(id_job) on delete cascade,
    nr_tel varchar2(15) constraint unq_tel_ang unique,
    email varchar2(30) constraint unq_email_ang unique constraint null_email_ang not null,
    data_ang date default sysdate
 );

--entitatea SPECIE
create table SPECIE(
    id_specie varchar2(25) constraint pk_specie primary key,
    tip_dieta varchar2(10) constraint null_dieta not null constraint check_dieta check(lower(tip_dieta) in ('carnivor','erbivor','omnivor')),
    colorit varchar2(60),
    tip_animal varchar2(20) constraint null_tip_sp not null constraint check_tip_sp check(lower(tip_animal) in ('nocturn','diurn','crepuscular')),
    varsta_medie number(4) constraint null_varsta not null,
    clasificare varchar2(20) constraint null_clasificare not null,
    nume_specie varchar2(35) constraint null_nume_sp not null
);

--entitatea ANIMALE
create table ANIMALE(
    id_animal number(4) constraint pk_animal primary key,
    nume varchar2(25) default 'No Name',
    varsta number(4) constraint null_varsta_anim not null constraint check_varsta check(varsta>=0),
    id_zoo number(4) constraint null_zoo_anim not null constraint fk_zoo_anim references GRADINA_ZOOLOGICA(id_zoo) on delete cascade,
    id_specie varchar2(25) constraint null_specie not null constraint fk_specie references SPECIE(id_specie) on delete cascade,
    temperament varchar2(60),
    varsta_luni number(4) constraint null_varsta_luni not null constraint check_varsta_luni check(varsta_luni>=0 and varsta_luni<12)
    
);

--entitatea TIP_RESTRICTIE
create table TIP_RESTRICTIE(
    tip_restrictie varchar2(20) constraint pk_tip_restrictie primary key,
    nume_restrictie varchar2(30) constraint null_nume_restrictie not null,
    descriere_restrictie varchar2(80) constraint null_descriere not null
);

--entitatea RESTRICTIE
create table RESTRICTIE(
    id_restrictie number(4) constraint pk_restrictie primary key,
    data_inceput date default sysdate constraint null_data_inc not null,
    data_sfarsit date default sysdate constraint null_data_sf not null,
    id_animal number(4) constraint null_animal not null constraint fk_animal_rest references ANIMALE(id_animal) on delete cascade,
    tip_restrictie varchar2(20) constraint null_tip_rest not null constraint fk_tip_rest references TIP_RESTRICTIE(tip_restrictie) on delete cascade,
    constraint check_data_sf check(data_sfarsit>=data_inceput)
);

--entitatea TIP_HRANA
create table TIP_HRANA(
    id_tip_hrana varchar2(20) constraint pk_tip_hrana primary key,
    nume_hrana varchar2(30) constraint null_nume_tip not null,
    origine varchar2(30) constraint null_origine_tip not null,
    sapt_valabilitate number(4) constraint null_valabilitate_tip not null constraint check_valabilitate_tip check(sapt_valabilitate>0)
);

--entitatea HRANA
create table HRANA(
    id_hrana number(4) constraint pk_hrana primary key,
    cantitate number(4) constraint null_cantitate_hrana not null constraint check_cantitate check(cantitate>0),
    id_zoo number(4) constraint null_zoo_hrana not null constraint fk_zoo_hrana references GRADINA_ZOOLOGICA(id_zoo) on delete cascade,
    id_tip_hrana varchar2(20) constraint null_tip_hrana not null constraint fk_tip_hrana references TIP_HRANA(id_tip_hrana) on delete cascade
);

--entitatea HRANESTE
create table HRANESTE(
    id_animal number(4) constraint fk_animal_hraneste references ANIMALE(id_animal) on delete cascade,
    id_ang number(4) constraint fk_ang_hraneste references ANGAJATI(id_ang) on delete cascade,
    id_hrana number(4) constraint fk_hrana_hraneste references HRANA(id_hrana) on delete cascade,
    data_hranire date,
    ora_hranire date,
    cantitate number(4) constraint null_cantitate_hraneste not null constraint check_cantitate_hraneste check(cantitate>0),
    constraint pk_animal_ang_hrana_data_ora primary key(id_animal,id_ang,id_hrana,data_hranire,ora_hranire)
);

--entitatea NUMAR_HRANA pentru exercitiul 10
create table NUMAR_HRANA(
    id_zoo number(4) constraint pk_numar_hrana primary key,
    nr number(4),
    constraint fk_zoo_nr_hrana foreign key (id_zoo) references gradina_zoologica(id_zoo)
);

--entitatea EVENIMENTE pentru exercitiul 12
create table evenimente(
    username varchar2(50),
    data_eveniment date,
    actiune varchar2(30),
    nume varchar2(30)
);

-- 5)Ad?uga?i informa?ii coerente în tabelele create (minim 5 înregistr?ri pentru fiecare 
-- entitate independent?; minim 10 înregistr?ri pentru tabela asociativ?).

--secventa care va ajuta in inserarea inregistrarilor in GRADINA_ZOOLOGICA
create sequence secv_zoo
increment by 1
start with 1
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in ANIMALE
create sequence secv_animale
increment by 1
start with 100
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in PARTENER
create sequence secv_part
increment by 10
start with 10
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in SERVICIU
create sequence secv_serv
increment by 5
start with 200
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in PRODUSE
create sequence secv_produs
increment by 10
start with 1000
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in ANGAJATI
create sequence secv_angajat
increment by 1
start with 500
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in RESTRICTIE
create sequence secv_restrictie
increment by 1
start with 300
maxvalue 9999
nocycle 
nocache;

--secventa care va ajuta in inserarea inregistrarilor in HRANA
create sequence secv_hrana
increment by 1
start with 700
maxvalue 9999
nocycle 
nocache;


--inseram inregistrari in PARTENER
insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'SUFIPAPER','Smith','jason.smith@gmail.com','0772561483','Sydney');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'MEROS','Jameson','ashley.jameson@gmail.com','0751483301','New York');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'KINGUS','Austin','bruce.austin@gmail.com',null,'Tokyo');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'CRONEKER','Mikks','brad.mikks@gmail.com','0772561553',null);

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'GRAEL','Williams','judy.williams@gmail.com','0760161273','San Francisco');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'TANG','Brown','rene.brown@gmail.com','0762351104','Mumbai');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'BLICH','Walker','jason.walker@gmail.com','0789210345',null);

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'ROWNE','Singer','robert.singer@gmail.com',null,'Rotterdam');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'BEGAS','Marconi','julie.marconi@gmail.com',null,'Paris');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'FARKIN','Roosevelt','tom.roosevelt@gmail.com','0733691024','Milan');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'REPHER','Kleinz','mauro.kleinz@gmail.com','0763500792','Frankfurt');

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'SCHLET','Pope','rebecca.pope@gmail.com',null,null);

insert into PARTENER(id_part,nume_partener,nume_contact,email_contact,nr_tel_contact,oras_sediu)
values(secv_part.nextval,'MISKEL','Baker','charis.baker@gmail.com','0768911732','Ironwood');


--inseram inregistrari in SERVICIU
insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Hartie','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Bani','Donatie');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Spectacol','Vanzare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Morcovi','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Suplimente','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Medicamente','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Medicamente','Donatie');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Furaje','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Spectacol Acvatic','Vanzare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Eveniment Privat','Vanzare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Seminte','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Carne de vita','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Carne de oaie','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Salata','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Vitamine','Achizitionare');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Vitamine','Donatie');

insert into SERVICIU(id_serviciu,nume_serviciu,tip_serviciu)
values (secv_serv.nextval,'Potcoave','Donatie');


--inseram inregistrari in GRADINA_ZOOLOGICA
insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Sydney',200);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Mumbai',200);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'New York',200);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Tokyo',300);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'San Francisco',350);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Singapore',360);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Kansas',195);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Bordeaux',400);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Bern',360);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Jakarta',400);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Detroit',250);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Marseille',270);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Ankara',320);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Boston',350);

insert into GRADINA_ZOOLOGICA(id_zoo,locatie,dimensiune)
values (secv_zoo.nextval,'Dublin',115);


--inseram inregistrari in BENEFICIAZA
insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,6,205,'11-MAY-2008','1000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,7,205,'11-MAY-2008','5000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,10,205,'11-MAY-2008','3500 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,13,225,'23-JUNE-2015','10 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,4,255,'18-NOV-2002','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,9,255,'20-DEC-2012','50 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,8,255,'18-JAN-2006','150 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,1,250,'11-AUG-2002','30 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,5,250,'11-JUL-2002','20 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,14,250,'20-AUG-2006','35 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,3,245,'21-APR-2013','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,2,265,'14-SEP-2011','30 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,10,270,'17-OCT-2001','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,10,200,'17-MAR-2021','3500 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,7,200,'18-MAR-2021','700 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,3,200,'22-MAR-2010','6000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,12,200,'02-MAR-2021','1600 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,14,200,'23-MAR-2021','4250 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,1,235,'10-JUL-2014','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,11,235,'10-JUL-2014','250 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,8,235,'07-JUL-2014','75 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,6,235,'10-JUL-2002','165 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,8,220,'20-JUN-2002','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,14,240,'11-AUG-2002','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,10,240,'27-JUN-2007','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,6,205,'5-JAN-2003','6000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,6,200,'8-DEC-2013','9000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,2,255,'26-MAY-2006','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,9,270,'19-OCT-2012','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,7,255,'1-MAY-2004','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,12,230,'24-MAY-2016','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,13,200,'18-JUL-2005','3000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,6,275,'28-SEP-2019','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,2,260,'7-JUN-2014','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,10,255,'13-MAY-2021','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,12,255,'27-JUN-2004','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,10,280,'24-JUN-2006','10 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,13,245,'5-OCT-2016','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,8,205,'16-JAN-2015','9000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,5,240,'5-DEC-2004','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,11,255,'11-JUL-2001','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,6,200,'23-AUG-2021','8000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,4,215,'2-AUG-2016','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,12,205,'18-MAY-2012','2000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,9,215,'18-JAN-2003','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,10,240,'28-OCT-2016','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,4,230,'4-FEB-2020','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,7,245,'27-MAY-2005','2 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,7,245,'21-JUL-2000','3 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,1,275,'1-JAN-2007','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,7,220,'17-MAY-2011','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,6,240,'22-APR-2013','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,14,215,'6-DEC-2014','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,7,220,'11-MAR-2014','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,10,265,'26-NOV-2002','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,8,210,'27-OCT-2012','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,9,200,'9-MAY-2017','5000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,5,240,'15-FEB-2002','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,4,260,'8-APR-2004','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,2,220,'9-MAR-2016','10 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,9,235,'6-DEC-2012','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,8,230,'8-NOV-2010','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,10,235,'11-DEC-2007','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,7,245,'28-OCT-2007','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,13,240,'15-NOV-2005','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,3,215,'22-OCT-2019','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,4,255,'7-JAN-2020','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,9,220,'6-MAR-2017','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,11,225,'26-JUL-2007','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,10,265,'12-MAY-2014','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,4,240,'19-MAR-2007','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,13,255,'17-NOV-2014','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,1,225,'9-FEB-2004','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,10,215,'8-FEB-2008','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,9,260,'12-JUN-2011','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,10,250,'9-JAN-2004','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,4,280,'21-SEP-2016','10 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,9,210,'20-JAN-2019','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,1,265,'8-JAN-2005','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,14,250,'6-MAR-2002','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,5,280,'22-AUG-2005','40 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,6,230,'22-MAY-2019','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,14,280,'8-APR-2017','100 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,8,235,'17-OCT-2018','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,9,255,'28-MAY-2009','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,3,210,'19-SEP-2010','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,1,245,'25-JAN-2017','3 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,11,225,'25-MAR-2008','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,10,255,'1-SEP-2015','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,11,280,'24-MAY-2007','20 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,8,230,'8-FEB-2016','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,8,220,'12-JUL-2013','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,4,245,'11-FEB-2011','2 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,1,250,'21-SEP-2000','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,3,245,'18-MAR-2006','3 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,5,270,'7-JUL-2016','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,5,210,'2-DEC-2007','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,11,210,'18-MAR-2017','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,7,245,'13-FEB-2006','4 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,3,260,'21-MAR-2006','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,2,205,'8-JUN-2013','7000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,2,220,'27-JUL-2004','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,1,265,'11-DEC-2018','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,12,215,'1-MAY-2014','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,3,260,'9-SEP-2002','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,14,280,'6-NOV-2013','40 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,11,270,'18-JUN-2011','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,2,260,'6-JUN-2006','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,7,280,'23-MAR-2011','70 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,5,270,'22-JAN-2003','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,12,225,'22-OCT-2012','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,5,275,'17-DEC-2016','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,8,275,'13-MAR-2020','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,9,280,'9-APR-2007','60 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,1,205,'7-NOV-2016','9000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,1,275,'20-SEP-2009','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,9,225,'13-FEB-2021','50 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,2,255,'16-JUN-2013','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,5,235,'18-NOV-2013','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,7,265,'6-OCT-2017','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,12,260,'17-MAY-2019','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,12,260,'10-FEB-2015','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,8,245,'26-APR-2003','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,13,265,'9-DEC-2008','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,11,220,'15-JUN-2016','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,9,205,'21-FEB-2001','7000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,2,200,'28-NOV-2010','9000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,2,240,'11-MAR-2001','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,7,250,'8-JUN-2018','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,2,270,'13-AUG-2006','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,6,215,'19-MAR-2004','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,12,250,'21-NOV-2013','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,11,270,'1-NOV-2009','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,11,265,'3-MAR-2011','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,12,215,'9-APR-2021','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,1,275,'25-OCT-2001','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,2,225,'17-MAY-2010','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,6,275,'15-AUG-2002','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,1,230,'11-AUG-2009','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,10,240,'6-APR-2011','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,2,270,'4-JAN-2013','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,8,270,'28-NOV-2001','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,6,240,'1-JUL-2005','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,2,235,'26-MAY-2011','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,12,235,'3-OCT-2007','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,8,255,'10-MAR-2013','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,14,215,'25-OCT-2002','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,14,220,'19-MAY-2012','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,7,255,'25-NOV-2017','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,5,265,'17-NOV-2014','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,1,240,'22-MAR-2010','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,9,265,'9-JAN-2000','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,3,260,'21-FEB-2016','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,6,225,'10-SEP-2021','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,4,230,'4-MAY-2009','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,12,225,'12-FEB-2011','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,14,235,'17-SEP-2007','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,14,270,'9-DEC-2011','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,1,235,'25-MAR-2017','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,12,265,'6-NOV-2014','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,12,210,'28-AUG-2017','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,7,225,'13-OCT-2004','90 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,1,260,'18-JUL-2012','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,10,225,'25-APR-2019','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,13,205,'27-JUN-2000','10000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,4,275,'25-NOV-2018','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,1,245,'7-JAN-2020','3 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,13,215,'22-JUL-2020','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,3,250,'18-NOV-2001','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,14,235,'28-NOV-2001','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,9,270,'2-JUL-2007','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,1,235,'26-JUL-2013','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,5,255,'18-JUN-2009','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,10,210,'20-SEP-2014','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,13,225,'18-MAR-2005','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,10,225,'17-JUN-2004','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,3,225,'28-FEB-2010','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,8,230,'8-SEP-2003','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,14,255,'12-AUG-2000','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,13,215,'24-APR-2014','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,14,215,'28-AUG-2019','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,14,260,'8-FEB-2009','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,2,220,'5-NOV-2015','10 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,13,275,'9-MAY-2005','50 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,9,215,'2-AUG-2006','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,11,240,'27-MAR-2020','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,2,225,'14-OCT-2014','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,13,215,'23-NOV-2016','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,10,225,'14-SEP-2003','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,11,265,'13-MAY-2002','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,10,250,'24-NOV-2019','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,10,280,'1-FEB-2000','90 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,1,235,'28-MAY-2007','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,4,270,'18-JAN-2003','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,1,245,'11-OCT-2020','4 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,8,255,'2-MAY-2003','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,14,205,'25-MAY-2016','7000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,13,255,'16-JUL-2003','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,2,225,'25-SEP-2021','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,5,210,'20-MAR-2014','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,7,260,'18-OCT-2018','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,7,250,'9-JUN-2007','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,8,210,'20-MAY-2013','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,2,270,'23-JAN-2002','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,3,280,'2-NOV-2002','60 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,10,205,'1-MAR-2014','1000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,7,225,'27-JUL-2012','50 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,11,210,'5-MAY-2019','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,5,235,'24-JAN-2008','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,14,245,'8-FEB-2011','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,5,270,'23-MAR-2009','50 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,11,220,'9-NOV-2017','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,5,260,'5-OCT-2012','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,2,250,'27-AUG-2005','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,4,215,'18-JUN-2004','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,12,240,'28-JAN-2002','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,4,200,'5-SEP-2000','3000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,2,245,'22-JUN-2013','3 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,12,235,'13-OCT-2000','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,10,250,'26-JUL-2001','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,13,230,'3-JUL-2004','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,12,230,'7-DEC-2007','100 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,5,240,'10-NOV-2002','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,6,255,'19-MAY-2007','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,5,270,'21-APR-2009','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,8,205,'1-MAY-2019','5000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,9,265,'6-JAN-2006','500 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,11,245,'25-JAN-2013','2 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,8,210,'4-JAN-2008','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,4,275,'22-OCT-2017','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,5,240,'19-MAY-2000','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,6,235,'23-JUN-2002','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,11,200,'26-APR-2021','8000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,10,210,'19-JUN-2003','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,6,260,'23-FEB-2011','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,13,275,'22-MAY-2013','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,1,255,'8-JUN-2009','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,5,245,'1-JAN-2012','3 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,3,205,'14-NOV-2009','8000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,1,280,'16-FEB-2020','70 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,14,270,'27-JUL-2002','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,6,215,'8-SEP-2021','100 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,5,205,'2-OCT-2019','4000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,14,245,'28-MAR-2004','4 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,3,215,'20-OCT-2010','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,7,235,'2-JUN-2021','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,5,200,'26-MAR-2012','1000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,10,220,'5-NOV-2015','60 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,10,210,'21-SEP-2003','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,6,265,'11-JUN-2012','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,3,265,'2-FEB-2004','800 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,13,210,'25-OCT-2008','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,7,270,'23-MAY-2013','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,10,205,'7-MAR-2011','10000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,10,245,'24-JUN-2016','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,5,205,'27-JUL-2013','6000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,12,255,'23-MAR-2021','900 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,8,200,'8-MAY-2010','7000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,14,250,'26-NOV-2001','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,6,275,'28-FEB-2013','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,3,265,'3-DEC-2007','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,4,220,'20-JAN-2012','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,9,210,'8-OCT-2001','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,14,215,'5-MAR-2006','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,3,250,'20-JUN-2011','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,1,245,'24-MAY-2000','4 evenimente');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,11,210,'10-APR-2012','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,9,200,'22-JUL-2004','5000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,14,200,'14-JUL-2009','6000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,9,230,'20-JAN-2000','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,6,215,'7-MAR-2013','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,5,230,'4-FEB-2006','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,9,200,'13-OCT-2005','3000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,6,225,'9-MAR-2017','70 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,9,220,'28-AUG-2001','10 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,7,210,'5-AUG-2016','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,9,225,'8-MAR-2015','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,3,240,'6-OCT-2004','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,3,235,'8-AUG-2013','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,3,240,'26-JAN-2018','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,8,200,'6-AUG-2008','6000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,10,275,'19-APR-2006','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,13,210,'6-FEB-2009','4 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,9,200,'9-NOV-2016','10000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,2,265,'16-FEB-2010','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,13,225,'15-NOV-2000','50 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,8,225,'18-MAR-2008','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,6,215,'16-APR-2014','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,5,245,'12-SEP-2002','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,1,260,'28-OCT-2014','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,14,240,'16-OCT-2004','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (60,10,280,'14-JAN-2013','40 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,11,205,'12-AUG-2000','4000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,10,255,'15-DEC-2003','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,2,245,'22-MAR-2002','1 eveniment');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,7,220,'23-MAY-2017','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,2,280,'25-AUG-2019','70 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,9,255,'28-JAN-2019','300 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,10,235,'1-FEB-2011','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,11,255,'27-NOV-2020','1000 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,9,240,'6-APR-2006','1 spectacol');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (120,1,210,'15-SEP-2001','3 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,6,220,'23-APR-2020','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,1,205,'9-FEB-2019','3000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,6,215,'27-OCT-2016','600 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (80,1,275,'19-JAN-2014','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,5,275,'12-MAY-2015','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,7,220,'8-JAN-2006','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,8,210,'9-AUG-2004','2 spectacole');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (90,5,275,'3-OCT-2010','40 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,14,205,'27-JAN-2008','8000 euro');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (50,10,260,'19-AUG-2018','200 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,6,200,'22-NOV-2016','10000 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (70,9,220,'14-SEP-2005','30 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (10,7,260,'8-FEB-2011','700 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,4,270,'19-NOV-2021','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (30,4,270,'24-MAY-2003','10 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,12,235,'1-JUL-2018','400 kilograme');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (100,7,220,'19-APR-2015','80 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (40,3,270,'6-DEC-2009','20 flacoane');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (20,13,280,'4-FEB-2017','90 bucati');

insert into BENEFICIAZA(id_part,id_zoo,id_serviciu,data_serviciu,cantitate)
values (110,10,215,'24-MAY-2017','100 kilograme');


--inseram inregistrari in PRODUSE
insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Elev','Carnet Elev',1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Student','Legitimatie Student',1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Elev Extins','Carnet Elev',7);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Student Extins','Legitimatie Student',7);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Extins',null,7);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Pensionar','Carnet Pensionar',1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Pensionar Extins','Carnet Pensionar',7);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Bilet Lunar',null,30);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Popcorn',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Popcorn cu caramel',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Apa',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Vata de zahar',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Inghetata',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Popcorn cu ciocolata',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Chipsuri',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Slushie Coacaze',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Slushie Capsuni',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Slushie Portocale',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Slushie Cirese',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Slushie Lamaie',null,1);

insert into PRODUSE(id_produs,nume_produs,cerinta_produs,valabilitate_zile)
values (secv_produs.nextval,'Milkshake Ciocolata',null,1);


--inseram inregistrari in VAND
insert into VAND(id_zoo,id_produs,cost)
values (1,1060,17);

insert into VAND(id_zoo,id_produs,cost)
values (1,1070,27);

insert into VAND(id_zoo,id_produs,cost)
values (1,1080,30);

insert into VAND(id_zoo,id_produs,cost)
values (1,1090,28);

insert into VAND(id_zoo,id_produs,cost)
values (1,1100,24);

insert into VAND(id_zoo,id_produs,cost)
values (1,1110,1);

insert into VAND(id_zoo,id_produs,cost)
values (1,1120,27);

insert into VAND(id_zoo,id_produs,cost)
values (1,1130,25);

insert into VAND(id_zoo,id_produs,cost)
values (1,1140,18);

insert into VAND(id_zoo,id_produs,cost)
values (1,1150,13);

insert into VAND(id_zoo,id_produs,cost)
values (1,1160,29);

insert into VAND(id_zoo,id_produs,cost)
values (1,1170,11);

insert into VAND(id_zoo,id_produs,cost)
values (1,1180,19);

insert into VAND(id_zoo,id_produs,cost)
values (1,1190,22);

insert into VAND(id_zoo,id_produs,cost)
values (2,1000,24);

insert into VAND(id_zoo,id_produs,cost)
values (2,1010,15);

insert into VAND(id_zoo,id_produs,cost)
values (2,1020,7);

insert into VAND(id_zoo,id_produs,cost)
values (2,1030,19);

insert into VAND(id_zoo,id_produs,cost)
values (2,1040,17);

insert into VAND(id_zoo,id_produs,cost)
values (2,1050,20);

insert into VAND(id_zoo,id_produs,cost)
values (2,1060,24);

insert into VAND(id_zoo,id_produs,cost)
values (2,1070,7);

insert into VAND(id_zoo,id_produs,cost)
values (2,1080,14);

insert into VAND(id_zoo,id_produs,cost)
values (2,1090,7);

insert into VAND(id_zoo,id_produs,cost)
values (2,1100,11);

insert into VAND(id_zoo,id_produs,cost)
values (2,1110,16);

insert into VAND(id_zoo,id_produs,cost)
values (2,1120,3);

insert into VAND(id_zoo,id_produs,cost)
values (2,1130,14);

insert into VAND(id_zoo,id_produs,cost)
values (2,1140,10);

insert into VAND(id_zoo,id_produs,cost)
values (2,1150,7);

insert into VAND(id_zoo,id_produs,cost)
values (2,1160,3);

insert into VAND(id_zoo,id_produs,cost)
values (3,1010,9);

insert into VAND(id_zoo,id_produs,cost)
values (3,1020,30);

insert into VAND(id_zoo,id_produs,cost)
values (3,1030,13);

insert into VAND(id_zoo,id_produs,cost)
values (3,1040,9);

insert into VAND(id_zoo,id_produs,cost)
values (3,1050,9);

insert into VAND(id_zoo,id_produs,cost)
values (3,1060,18);

insert into VAND(id_zoo,id_produs,cost)
values (3,1070,19);

insert into VAND(id_zoo,id_produs,cost)
values (3,1080,19);

insert into VAND(id_zoo,id_produs,cost)
values (3,1090,22);

insert into VAND(id_zoo,id_produs,cost)
values (3,1100,26);

insert into VAND(id_zoo,id_produs,cost)
values (3,1110,30);

insert into VAND(id_zoo,id_produs,cost)
values (3,1120,12);

insert into VAND(id_zoo,id_produs,cost)
values (3,1130,26);

insert into VAND(id_zoo,id_produs,cost)
values (3,1140,30);

insert into VAND(id_zoo,id_produs,cost)
values (3,1150,4);

insert into VAND(id_zoo,id_produs,cost)
values (3,1160,18);

insert into VAND(id_zoo,id_produs,cost)
values (4,1070,16);

insert into VAND(id_zoo,id_produs,cost)
values (4,1080,13);

insert into VAND(id_zoo,id_produs,cost)
values (4,1090,7);

insert into VAND(id_zoo,id_produs,cost)
values (4,1100,2);

insert into VAND(id_zoo,id_produs,cost)
values (4,1110,28);

insert into VAND(id_zoo,id_produs,cost)
values (4,1120,1);

insert into VAND(id_zoo,id_produs,cost)
values (4,1130,30);

insert into VAND(id_zoo,id_produs,cost)
values (4,1140,12);

insert into VAND(id_zoo,id_produs,cost)
values (4,1150,28);

insert into VAND(id_zoo,id_produs,cost)
values (4,1160,3);

insert into VAND(id_zoo,id_produs,cost)
values (4,1170,13);

insert into VAND(id_zoo,id_produs,cost)
values (4,1180,4);

insert into VAND(id_zoo,id_produs,cost)
values (4,1190,11);

insert into VAND(id_zoo,id_produs,cost)
values (5,1000,11);

insert into VAND(id_zoo,id_produs,cost)
values (5,1010,26);

insert into VAND(id_zoo,id_produs,cost)
values (5,1020,8);

insert into VAND(id_zoo,id_produs,cost)
values (5,1030,9);

insert into VAND(id_zoo,id_produs,cost)
values (5,1040,26);

insert into VAND(id_zoo,id_produs,cost)
values (5,1050,12);

insert into VAND(id_zoo,id_produs,cost)
values (5,1060,24);

insert into VAND(id_zoo,id_produs,cost)
values (5,1070,24);

insert into VAND(id_zoo,id_produs,cost)
values (5,1080,11);

insert into VAND(id_zoo,id_produs,cost)
values (5,1090,11);

insert into VAND(id_zoo,id_produs,cost)
values (5,1100,8);

insert into VAND(id_zoo,id_produs,cost)
values (5,1110,16);

insert into VAND(id_zoo,id_produs,cost)
values (5,1120,17);

insert into VAND(id_zoo,id_produs,cost)
values (5,1130,23);

insert into VAND(id_zoo,id_produs,cost)
values (5,1140,25);

insert into VAND(id_zoo,id_produs,cost)
values (5,1150,28);

insert into VAND(id_zoo,id_produs,cost)
values (6,1090,21);

insert into VAND(id_zoo,id_produs,cost)
values (6,1100,7);

insert into VAND(id_zoo,id_produs,cost)
values (6,1110,3);

insert into VAND(id_zoo,id_produs,cost)
values (6,1120,25);

insert into VAND(id_zoo,id_produs,cost)
values (6,1130,6);

insert into VAND(id_zoo,id_produs,cost)
values (6,1140,5);

insert into VAND(id_zoo,id_produs,cost)
values (6,1150,30);

insert into VAND(id_zoo,id_produs,cost)
values (6,1160,17);

insert into VAND(id_zoo,id_produs,cost)
values (6,1170,6);

insert into VAND(id_zoo,id_produs,cost)
values (6,1180,28);

insert into VAND(id_zoo,id_produs,cost)
values (6,1190,11);

insert into VAND(id_zoo,id_produs,cost)
values (7,1000,9);

insert into VAND(id_zoo,id_produs,cost)
values (7,1010,30);

insert into VAND(id_zoo,id_produs,cost)
values (7,1020,10);

insert into VAND(id_zoo,id_produs,cost)
values (7,1030,27);

insert into VAND(id_zoo,id_produs,cost)
values (7,1040,8);

insert into VAND(id_zoo,id_produs,cost)
values (7,1050,26);

insert into VAND(id_zoo,id_produs,cost)
values (7,1060,11);

insert into VAND(id_zoo,id_produs,cost)
values (7,1070,23);

insert into VAND(id_zoo,id_produs,cost)
values (7,1080,7);

insert into VAND(id_zoo,id_produs,cost)
values (7,1090,17);

insert into VAND(id_zoo,id_produs,cost)
values (7,1100,29);

insert into VAND(id_zoo,id_produs,cost)
values (7,1190,14);

insert into VAND(id_zoo,id_produs,cost)
values (8,1000,22);

insert into VAND(id_zoo,id_produs,cost)
values (8,1010,10);

insert into VAND(id_zoo,id_produs,cost)
values (8,1020,21);

insert into VAND(id_zoo,id_produs,cost)
values (8,1030,11);

insert into VAND(id_zoo,id_produs,cost)
values (8,1040,9);

insert into VAND(id_zoo,id_produs,cost)
values (8,1050,10);

insert into VAND(id_zoo,id_produs,cost)
values (8,1060,12);

insert into VAND(id_zoo,id_produs,cost)
values (8,1070,23);

insert into VAND(id_zoo,id_produs,cost)
values (8,1080,23);

insert into VAND(id_zoo,id_produs,cost)
values (8,1090,18);

insert into VAND(id_zoo,id_produs,cost)
values (8,1100,2);

insert into VAND(id_zoo,id_produs,cost)
values (8,1110,8);

insert into VAND(id_zoo,id_produs,cost)
values (8,1120,6);

insert into VAND(id_zoo,id_produs,cost)
values (8,1130,26);

insert into VAND(id_zoo,id_produs,cost)
values (8,1140,11);

insert into VAND(id_zoo,id_produs,cost)
values (8,1150,16);

insert into VAND(id_zoo,id_produs,cost)
values (8,1160,2);

insert into VAND(id_zoo,id_produs,cost)
values (8,1170,18);

insert into VAND(id_zoo,id_produs,cost)
values (8,1180,2);

insert into VAND(id_zoo,id_produs,cost)
values (8,1190,25);

insert into VAND(id_zoo,id_produs,cost)
values (9,1000,20);

insert into VAND(id_zoo,id_produs,cost)
values (9,1010,25);

insert into VAND(id_zoo,id_produs,cost)
values (9,1020,3);

insert into VAND(id_zoo,id_produs,cost)
values (9,1030,17);

insert into VAND(id_zoo,id_produs,cost)
values (9,1040,17);

insert into VAND(id_zoo,id_produs,cost)
values (9,1050,16);

insert into VAND(id_zoo,id_produs,cost)
values (9,1060,22);

insert into VAND(id_zoo,id_produs,cost)
values (9,1070,30);

insert into VAND(id_zoo,id_produs,cost)
values (9,1080,11);

insert into VAND(id_zoo,id_produs,cost)
values (9,1090,25);

insert into VAND(id_zoo,id_produs,cost)
values (9,1100,19);

insert into VAND(id_zoo,id_produs,cost)
values (9,1110,7);

insert into VAND(id_zoo,id_produs,cost)
values (9,1120,23);

insert into VAND(id_zoo,id_produs,cost)
values (9,1130,23);

insert into VAND(id_zoo,id_produs,cost)
values (9,1140,25);

insert into VAND(id_zoo,id_produs,cost)
values (9,1150,10);

insert into VAND(id_zoo,id_produs,cost)
values (9,1160,20);

insert into VAND(id_zoo,id_produs,cost)
values (9,1170,19);

insert into VAND(id_zoo,id_produs,cost)
values (9,1180,20);

insert into VAND(id_zoo,id_produs,cost)
values (9,1190,11);

insert into VAND(id_zoo,id_produs,cost)
values (10,1000,30);

insert into VAND(id_zoo,id_produs,cost)
values (10,1010,25);

insert into VAND(id_zoo,id_produs,cost)
values (10,1020,30);

insert into VAND(id_zoo,id_produs,cost)
values (10,1030,19);

insert into VAND(id_zoo,id_produs,cost)
values (10,1040,27);

insert into VAND(id_zoo,id_produs,cost)
values (10,1050,27);

insert into VAND(id_zoo,id_produs,cost)
values (10,1060,16);

insert into VAND(id_zoo,id_produs,cost)
values (10,1070,25);

insert into VAND(id_zoo,id_produs,cost)
values (10,1080,19);

insert into VAND(id_zoo,id_produs,cost)
values (10,1090,16);

insert into VAND(id_zoo,id_produs,cost)
values (10,1100,18);

insert into VAND(id_zoo,id_produs,cost)
values (10,1110,1);

insert into VAND(id_zoo,id_produs,cost)
values (10,1120,1);

insert into VAND(id_zoo,id_produs,cost)
values (10,1130,29);

insert into VAND(id_zoo,id_produs,cost)
values (10,1140,24);

insert into VAND(id_zoo,id_produs,cost)
values (10,1150,1);

insert into VAND(id_zoo,id_produs,cost)
values (10,1160,2);

insert into VAND(id_zoo,id_produs,cost)
values (11,1150,6);

insert into VAND(id_zoo,id_produs,cost)
values (11,1160,23);

insert into VAND(id_zoo,id_produs,cost)
values (11,1170,18);

insert into VAND(id_zoo,id_produs,cost)
values (11,1180,9);

insert into VAND(id_zoo,id_produs,cost)
values (11,1190,29);

insert into VAND(id_zoo,id_produs,cost)
values (12,1000,12);

insert into VAND(id_zoo,id_produs,cost)
values (12,1010,4);

insert into VAND(id_zoo,id_produs,cost)
values (12,1020,15);

insert into VAND(id_zoo,id_produs,cost)
values (12,1030,27);

insert into VAND(id_zoo,id_produs,cost)
values (12,1040,6);

insert into VAND(id_zoo,id_produs,cost)
values (12,1050,18);

insert into VAND(id_zoo,id_produs,cost)
values (12,1060,5);

insert into VAND(id_zoo,id_produs,cost)
values (12,1070,5);

insert into VAND(id_zoo,id_produs,cost)
values (12,1080,4);

insert into VAND(id_zoo,id_produs,cost)
values (12,1090,14);

insert into VAND(id_zoo,id_produs,cost)
values (12,1100,3);

insert into VAND(id_zoo,id_produs,cost)
values (12,1110,3);

insert into VAND(id_zoo,id_produs,cost)
values (12,1120,20);

insert into VAND(id_zoo,id_produs,cost)
values (12,1130,1);

insert into VAND(id_zoo,id_produs,cost)
values (12,1140,14);

insert into VAND(id_zoo,id_produs,cost)
values (12,1150,8);

insert into VAND(id_zoo,id_produs,cost)
values (12,1160,5);

insert into VAND(id_zoo,id_produs,cost)
values (12,1170,3);

insert into VAND(id_zoo,id_produs,cost)
values (12,1180,13);

insert into VAND(id_zoo,id_produs,cost)
values (13,1060,2);

insert into VAND(id_zoo,id_produs,cost)
values (13,1070,13);

insert into VAND(id_zoo,id_produs,cost)
values (13,1080,2);

insert into VAND(id_zoo,id_produs,cost)
values (13,1090,11);

insert into VAND(id_zoo,id_produs,cost)
values (13,1100,13);

insert into VAND(id_zoo,id_produs,cost)
values (13,1110,2);

insert into VAND(id_zoo,id_produs,cost)
values (13,1120,18);

insert into VAND(id_zoo,id_produs,cost)
values (13,1130,29);

insert into VAND(id_zoo,id_produs,cost)
values (13,1140,2);

insert into VAND(id_zoo,id_produs,cost)
values (13,1150,22);

insert into VAND(id_zoo,id_produs,cost)
values (13,1160,28);

insert into VAND(id_zoo,id_produs,cost)
values (13,1170,25);

insert into VAND(id_zoo,id_produs,cost)
values (13,1180,30);

insert into VAND(id_zoo,id_produs,cost)
values (13,1190,23);

insert into VAND(id_zoo,id_produs,cost)
values (14,1000,5);

insert into VAND(id_zoo,id_produs,cost)
values (14,1100,29);

insert into VAND(id_zoo,id_produs,cost)
values (14,1110,6);

insert into VAND(id_zoo,id_produs,cost)
values (14,1120,20);

insert into VAND(id_zoo,id_produs,cost)
values (14,1130,1);

insert into VAND(id_zoo,id_produs,cost)
values (14,1140,20);

insert into VAND(id_zoo,id_produs,cost)
values (14,1150,8);

insert into VAND(id_zoo,id_produs,cost)
values (14,1160,3);

insert into VAND(id_zoo,id_produs,cost)
values (14,1170,7);

insert into VAND(id_zoo,id_produs,cost)
values (14,1180,23);

insert into VAND(id_zoo,id_produs,cost)
values (14,1190,26);

insert into VAND(id_zoo,id_produs,cost)
values (2,1210,7);

insert into VAND(id_zoo,id_produs,cost)
values (5,1210,6);


--inseram inregistrari in JOBS
insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('VANZ_PROD','Vanzator de produse',1000,5000);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('INGRJ','Ingrijitor animale',2500,6300);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('VTRNR','Veterinar',4000,10000);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('GHD','Ghid',3000,7000);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('CNTBL','Contabil',2000,5500);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('ADMN','Administrator',5000,12000);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('REL_EXT','Relatii externe',3300,7700);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('MCNC','Mecanic',3500,6500);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('DRSR','Dresor',2700,5900);

insert into JOBS(id_job,titlu_job,salariu_min,salariu_max)
values ('SRVC','Om de serviciu',1800,4500);


--inseram inregistrari in ANGAJATI
insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lam','Brit',2700,1,'SRVC','0787513945','brit.lam@gmail.com','19-MAY-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Brown','Rhonda',2800,1,'SRVC','0781349745','rhonda.brown@gmail.com','29-JUL-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email)
values (secv_angajat.nextval,'Kuroki','Patrocinia',2000,1,'SRVC',null,'patrocinia.kuroki@gmail.com');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Jones','Valerie',10000,1,'ADMN','0744220556','valerie.jones@gmail.com','09-APR-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Horvat','Achim',4700,1,'MCNC','0733404408','achim.horvat@gmail.com','12-DEC-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hakim','Cadmus',5500,1,'MCNC','0745239526','cadmus.hakim@gmail.com','11-OCT-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Beck','Eliza',5400,1,'DRSR','0756554712','eliza.beck@gmail.com','22-SEP-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rhodes','Vanesa',5900,1,'DRSR','0733659127','vanesa.rhodes@gmail.com','02-AUG-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Stanford','Tatiana',7500,1,'REL_EXT','0711957668','tatiana.stanford@gmail.com','27-JUN-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ma','Yusra',4000,1,'CNTBL','0771524366','yusra.ma@gmail.com','24-JAN-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Milan','Lucas',6000,1,'GHD','0786324912','lucas.milan@gmail.com','22-FEB-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Kramer','Anubis',5700,1,'GHD','0774552891','anubis.kramer@gmail.com','19-NOV-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Dwight','Emilia',8000,1,'VTRNR','0752272512','emilia.dwight@gmail.com','20-OCT-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hildegard','Kapel',8900,1,'VTRNR','0744811814','kapel.hildegard@gmail.com','06-OCT-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Seward','Malte',3500,1,'VANZ_PROD','0744659821','malte.seward@gmail.com','06-JAN-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Kiefer','Zarah',3000,1,'VANZ_PROD','0777153982','zarah.kiefer@gmail.com','13-MAY-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'White','Goda',4000,1,'INGRJ','0744194562','goda.white@gmail.com','01-JUN-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ng','Fenne',5000,1,'INGRJ','0726718448','fenne.ng@gmail.com','23-MAY-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Nyilas','Wilhelm',6000,1,'INGRJ','0720215613','wilhelm.nyilas@gmail.com','18-APR-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cunningham','Mahir',3000,2,'SRVC','0788523416','mahir.cunningham@gmail.com','02-MAY-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Doyle','Korey',3300,2,'SRVC','0763354489','korey.doyle@gmail.com','13-JAN-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email)
values (secv_angajat.nextval,'Slater','Kenan',4000,2,'SRVC',null,'kenan.slater@gmail.com');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mill','Tamar',11000,2,'ADMN','0711134659','tamar.mill@gmail.com','12-APR-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Iles','Leona',4200,2,'MCNC','0774433256','leona.iles@gmail.com','12-JAN-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Owens','Kylie',5700,2,'MCNC','07788996152','kylie.owens@gmail.com','02-NOV-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Nielsen','Timur',5900,2,'DRSR','0742425896','timur.nielsen@gmail.com','13-JAN-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Connor','Manav',5400,2,'DRSR','0712559864','connor.manav@gmail.com','02-AUG-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bain','Justin',7700,2,'REL_EXT','0722662845','justin.bain@gmail.com','10-JUL-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Friedman','Vera',5000,2,'CNTBL','0714224536','vera.friedman@gmail.com','24-MAY-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Irwin','Tommy',3500,2,'GHD','0799645645','tommy.irwin@gmail.com','01-NOV-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'McConnel','Stefano',4300,2,'GHD','0732324458','stefano.mcconnel@gmail.com','20-OCT-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Herring','Cara',9000,2,'VTRNR','0776655989','cara.herring@gmail.com','13-FEB-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Orr','Olive',8700,2,'VTRNR','0723142135','olive.orr@gmail.com','07-JAN-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Knott','Wyatt',2700,2,'VANZ_PROD','0778885596','wyatt.knott@gmail.com','07-OCT-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Pike','Saima',3300,2,'VANZ_PROD','0775252563','saima.pike@gmail.com','08-JUN-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ried','Adil',4200,2,'INGRJ','0772341526','adil.ried@gmail.com','16-MAY-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rahman','Mikaeel',47000,2,'INGRJ','0785896326','mikaeel.rahman@gmail.com','15-JUL-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rodriguez','Elaine',6100,2,'INGRJ','0725896145','elaine.rodriguez@gmail.com','22-APR-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Richmond','Dylon',4000,3,'SRVC','0735709285','dylon.richmond@gmail.com','9-SEP-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Spears','Lylah',1900,3,'SRVC','0775373270','lylah.spears@gmail.com','3-JUL-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Clifford','Kareena',3300,3,'SRVC','0725254195','kareena.clifford@gmail.com','26-AUG-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Steadman','Ajwa',7300,3,'ADMN','0713892758','ajwa.steadman@gmail.com','11-APR-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Burn','Alanis',4500,3,'MCNC','0798840894','alanis.burn@gmail.com','7-APR-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Joyner','Abubakar',5100,3,'MCNC','0757615521','abubakar.joyner@gmail.com','19-SEP-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Frank','Safiyyah',3000,3,'DRSR','0705251364','safiyyah.frank@gmail.com','21-MAR-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Dotson','Harvey-Lee',3300,3,'DRSR','0769881834','harvey-lee.dotson@gmail.com','21-JUL-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Howard','Byron',6600,3,'REL_EXT','0704648442','byron.howard@gmail.com','3-JUN-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Serrano','Carol',2100,3,'CNTBL','0748899027','carol.serrano@gmail.com','13-FEB-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'East','Alistair',5600,3,'GHD','0789959319','alistair.east@gmail.com','27-SEP-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mccormack','Vivek',4900,3,'GHD','0718429852','vivek.mccormack@gmail.com','22-NOV-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Galvan','Fox',8400,3,'VTRNR','0700189799','fox.galvan@gmail.com','22-SEP-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cash','Ishika',7200,3,'VTRNR','0740710751','ishika.cash@gmail.com','7-JUN-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Gordon','Danika',1300,3,'VANZ_PROD','0773720403','danika.gordon@gmail.com','24-JAN-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Alford','Aayan',3200,3,'VANZ_PROD','0776664211','aayan.alford@gmail.com','24-OCT-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Brookes','Amar',5700,3,'INGRJ','0772621320','amar.brookes@gmail.com','18-DEC-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mathis','Rochelle',4600,3,'INGRJ','0781807958','rochelle.mathis@gmail.com','9-JUN-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Pritchard','Eilish',5100,3,'INGRJ','0745913643','eilish.pritchard@gmail.com','7-MAR-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Vickers','Ethel',2600,4,'SRVC','0741390532','ethel.vickers@gmail.com','3-APR-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hooper','Ewan',2800,4,'SRVC','0785693531','ewan.hooper@gmail.com','15-JUN-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Frey','Emilie',2300,4,'SRVC','0710388709','emilie.frey@gmail.com','15-MAY-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Guest','Monika',6400,4,'ADMN','0775733249','monika.guest@gmail.com','28-SEP-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bartlett','Eisa',3900,4,'MCNC','0782048548','eisa.bartlett@gmail.com','18-APR-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Heath','Aadam',5100,4,'MCNC','0784547635','aadam.heath@gmail.com','3-MAY-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Charlton','Amelie',4700,4,'DRSR','0702093404','amelie.charlton@gmail.com','4-AUG-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Riddle','Ashanti',4600,4,'DRSR','0738482372','ashanti.riddle@gmail.com','27-JUL-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Zuniga','Arthur',7400,4,'REL_EXT','0790081090','arthur.zuniga@gmail.com','4-SEP-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Richards','Ajay',4000,4,'CNTBL','0751259298','ajay.richards@gmail.com','23-JUN-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hopkins','Hilda',3100,4,'GHD','0750911129','hilda.hopkins@gmail.com','4-DEC-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Oneill','Kimberley',4200,4,'GHD','0789205338','kimberley.oneill@gmail.com','25-AUG-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Barrett','Layla-Mae',4600,4,'VTRNR','0799446189','layla-mae.barrett@gmail.com','6-AUG-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bentley','Brian',8800,4,'VTRNR','0701630938','brian.bentley@gmail.com','9-SEP-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mitchell','Arabella',1500,4,'VANZ_PROD','0739164530','arabella.mitchell@gmail.com','22-JAN-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lyon','Rumaisa',2400,4,'VANZ_PROD','0759680551','rumaisa.lyon@gmail.com','9-JAN-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Choi','Gerald',3900,4,'INGRJ','0724176502','gerald.choi@gmail.com','25-JUL-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'George','Inaayah',4400,4,'INGRJ','0766403545','inaayah.george@gmail.com','18-AUG-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Walsh','Nikkita',3700,4,'INGRJ','0780241545','nikkita.walsh@gmail.com','5-JUL-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Wickens','Laibah',4400,5,'SRVC','0792711294','laibah.wickens@gmail.com','20-JUL-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bowler','Caitlyn',2700,5,'SRVC','0743780750','caitlyn.bowler@gmail.com','5-JAN-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Villanueva','Stefanie',2000,5,'SRVC','0780805532','stefanie.villanueva@gmail.com','28-AUG-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Esquivel','Lulu',10700,5,'ADMN','0797165197','lulu.esquivel@gmail.com','25-FEB-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Richmond','Lorraine',4200,5,'MCNC','0748275169','lorraine.richmond@gmail.com','4-DEC-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Fowler','Herman',5200,5,'MCNC','0717950395','herman.fowler@gmail.com','11-AUG-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Stephenson','Ziva',5700,5,'DRSR','0746187135','ziva.stephenson@gmail.com','17-DEC-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Poole','Angela',5200,5,'DRSR','0783648088','angela.poole@gmail.com','18-JUN-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Underwood','Anaiya',4300,5,'REL_EXT','0757000488','anaiya.underwood@gmail.com','14-APR-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Blackmore','Samera',3200,5,'CNTBL','0798665202','samera.blackmore@gmail.com','7-MAR-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Barton','Cora',4900,5,'GHD','0783572017','cora.barton@gmail.com','10-JUL-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Best','Jessica',6500,5,'GHD','0710371090','jessica.best@gmail.com','20-JUL-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Beach','Shaurya',5400,5,'VTRNR','0789304954','shaurya.beach@gmail.com','15-JUL-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Marshall','Kyra',9900,5,'VTRNR','0765018851','kyra.marshall@gmail.com','1-SEP-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Woodward','Daniel',4700,5,'VANZ_PROD','0724621721','daniel.woodward@gmail.com','21-JUL-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cohen','Hamza',1000,5,'VANZ_PROD','0700004097','hamza.cohen@gmail.com','14-NOV-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bonner','Daryl',6000,5,'INGRJ','0744752041','daryl.bonner@gmail.com','6-JUL-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'England','Miranda',4500,5,'INGRJ','0705205061','miranda.england@gmail.com','4-JUN-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Brookes','Ryley',5400,5,'INGRJ','0734626274','ryley.brookes@gmail.com','21-SEP-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ireland','Vivaan',2400,6,'SRVC','0732791851','vivaan.ireland@gmail.com','7-SEP-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Butt','Elena',2700,6,'SRVC','0781448865','elena.butt@gmail.com','26-JUN-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lambert','Willard',2300,6,'SRVC','0711702431','willard.lambert@gmail.com','3-MAR-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Calderon','Varun',9900,6,'ADMN','0775986697','varun.calderon@gmail.com','26-FEB-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Workman','Georgiana',6200,6,'MCNC','0738693204','georgiana.workman@gmail.com','10-NOV-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lynn','Lexi-Mae',4800,6,'MCNC','0782028487','lexi-mae.lynn@gmail.com','20-FEB-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Pratt','Tasmin',3300,6,'DRSR','0799847340','tasmin.pratt@gmail.com','23-OCT-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rubio','Aleksander',3400,6,'DRSR','0749822396','aleksander.rubio@gmail.com','9-AUG-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Salgado','Rosalie',4000,6,'REL_EXT','0706544968','rosalie.salgado@gmail.com','23-AUG-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Kramer','Dalia',4600,6,'CNTBL','0707332476','dalia.kramer@gmail.com','20-OCT-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Phan','Fateh',4100,6,'GHD','0773204233','fateh.phan@gmail.com','12-MAY-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'House','Dominick',5100,6,'GHD','0769702121','dominick.house@gmail.com','23-SEP-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bowes','Orlaith',6200,6,'VTRNR','0766684609','orlaith.bowes@gmail.com','14-JAN-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Conroy','Jarrod',4200,6,'VTRNR','0737736243','jarrod.conroy@gmail.com','15-NOV-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ali','Lucinda',4300,6,'VANZ_PROD','0769235929','lucinda.ali@gmail.com','26-MAR-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Martinez','Beatrix',1200,6,'VANZ_PROD','0772572790','beatrix.martinez@gmail.com','23-SEP-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Glenn','Omer',4800,6,'INGRJ','0708022593','omer.glenn@gmail.com','9-APR-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Griffin','Saba',5300,6,'INGRJ','0781981300','saba.griffin@gmail.com','9-OCT-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hurley','Bridie',5200,6,'INGRJ','0713056897','bridie.hurley@gmail.com','16-NOV-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bean','Ignacy',3600,7,'SRVC','0726399865','ignacy.bean@gmail.com','13-DEC-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bender','Ruari',2300,7,'SRVC','0706779998','ruari.bender@gmail.com','18-MAR-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hubbard','Kelsey',3100,7,'SRVC','0790650171','kelsey.hubbard@gmail.com','5-DEC-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cash','Aaminah',8500,7,'ADMN','0713864454','aaminah.cash@gmail.com','5-OCT-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Reilly','Yusuf',3900,7,'MCNC','0741938395','yusuf.reilly@gmail.com','15-FEB-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hulme','Iain',4000,7,'MCNC','0794545237','iain.hulme@gmail.com','4-MAY-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Alston','Connar',3300,7,'DRSR','0709859272','connar.alston@gmail.com','13-MAR-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bains','Khia',5600,7,'DRSR','0745676741','khia.bains@gmail.com','4-FEB-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Sykes','June',3500,7,'REL_EXT','0768215369','june.sykes@gmail.com','28-OCT-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lin','Rizwan',2200,7,'CNTBL','0789761285','rizwan.lin@gmail.com','22-DEC-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Barajas','Amin',5200,7,'GHD','0761375875','amin.barajas@gmail.com','6-SEP-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Yang','Rishi',5900,7,'GHD','0722530657','rishi.yang@gmail.com','18-SEP-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Nairn','Dominykas',6900,7,'VTRNR','0769601724','dominykas.nairn@gmail.com','21-AUG-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Nolan','Ines',6500,7,'VTRNR','0760464366','ines.nolan@gmail.com','1-JAN-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cairns','Amalia',2900,7,'VANZ_PROD','0749185893','amalia.cairns@gmail.com','9-AUG-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Squires','Suhail',1300,7,'VANZ_PROD','0759916178','suhail.squires@gmail.com','18-JAN-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Christie','Murphy',3600,7,'INGRJ','0765994058','murphy.christie@gmail.com','6-JAN-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Shea','Perry',3500,7,'INGRJ','0701963686','perry.shea@gmail.com','28-APR-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Arias','Reem',3700,7,'INGRJ','0701708493','reem.arias@gmail.com','11-MAR-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Justice','Hanan',4100,8,'SRVC','0775045096','hanan.justice@gmail.com','16-AUG-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Frey','Rubi',2200,8,'SRVC','0751842376','rubi.frey@gmail.com','27-JUN-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Charles','Emanuel',2800,8,'SRVC','0783817598','emanuel.charles@gmail.com','9-AUG-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ratliff','Enzo',8500,8,'ADMN','0793090860','enzo.ratliff@gmail.com','5-APR-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Branch','Isla-Rae',3500,8,'MCNC','0794182313','isla-rae.branch@gmail.com','11-FEB-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mejia','Bobbi',6400,8,'MCNC','0763819428','bobbi.mejia@gmail.com','20-FEB-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Corbett','Kady',5400,8,'DRSR','0706010531','kady.corbett@gmail.com','14-JUN-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Peck','Conall',5000,8,'DRSR','0780671983','conall.peck@gmail.com','5-MAY-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Delaney','Luca',6900,8,'REL_EXT','0747656986','luca.delaney@gmail.com','11-FEB-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Trejo','Amirah',4500,8,'CNTBL','0767677347','amirah.trejo@gmail.com','20-APR-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Holden','Abbigail',4500,8,'GHD','0756876126','abbigail.holden@gmail.com','24-OCT-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hull','Danielle',4500,8,'GHD','0728313964','danielle.hull@gmail.com','28-MAY-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Harrington','Hasnain',8300,8,'VTRNR','0781300102','hasnain.harrington@gmail.com','24-MAR-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Proctor','Allison',7700,8,'VTRNR','0732512238','allison.proctor@gmail.com','28-MAY-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Simpson','Sarina',4600,8,'VANZ_PROD','0768145149','sarina.simpson@gmail.com','24-SEP-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Simmonds','Haya',4000,8,'VANZ_PROD','0788724606','haya.simmonds@gmail.com','10-AUG-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Turnbull','Helena',4700,8,'INGRJ','0769482656','helena.turnbull@gmail.com','6-JUL-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Case','Xena',4700,8,'INGRJ','0792591915','xena.case@gmail.com','7-APR-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'May','Cieran',5100,8,'INGRJ','0728474473','cieran.may@gmail.com','4-NOV-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Valencia','Ari',4100,9,'SRVC','0796327621','ari.valencia@gmail.com','21-MAY-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Donaldson','Asif',2700,9,'SRVC','0722349081','asif.donaldson@gmail.com','11-NOV-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Guerra','Essa',3800,9,'SRVC','0788090194','essa.guerra@gmail.com','28-SEP-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Stewart','Fergus',11500,9,'ADMN','0714761395','fergus.stewart@gmail.com','8-NOV-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Blackburn','Ross',3900,9,'MCNC','0782973110','ross.blackburn@gmail.com','24-JUN-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hodgson','Nayan',5000,9,'MCNC','0723692840','nayan.hodgson@gmail.com','25-NOV-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Carty','Theodore',5300,9,'DRSR','0757111797','theodore.carty@gmail.com','17-JUN-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Salter','Conah',2700,9,'DRSR','0734098755','conah.salter@gmail.com','24-MAY-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mckay','Maison',4200,9,'REL_EXT','0750679109','maison.mckay@gmail.com','20-JUL-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Kirk','Honey',5400,9,'CNTBL','0763151700','honey.kirk@gmail.com','16-NOV-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mcphee','Colton',6500,9,'GHD','0769050797','colton.mcphee@gmail.com','14-NOV-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Peel','Ana',6400,9,'GHD','0780104633','ana.peel@gmail.com','20-MAY-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Legge','Kelise',6500,9,'VTRNR','0714933411','kelise.legge@gmail.com','26-JUN-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Coles','Sayed',5400,9,'VTRNR','0739506936','sayed.coles@gmail.com','2-DEC-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Boyce','Alishia',4300,9,'VANZ_PROD','0791722525','alishia.boyce@gmail.com','15-JAN-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Farrow','Whitney',3200,9,'VANZ_PROD','0759106691','whitney.farrow@gmail.com','27-JUN-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Phan','Aliya',2500,9,'INGRJ','0735244887','aliya.phan@gmail.com','3-MAY-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ross','Iona',2800,9,'INGRJ','0764183555','iona.ross@gmail.com','25-FEB-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mullins','Blanche',3600,9,'INGRJ','0774950395','blanche.mullins@gmail.com','2-MAY-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Foster','Azra',2500,10,'SRVC','0706601216','azra.foster@gmail.com','15-DEC-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mckinney','Ariadne',3600,10,'SRVC','0799860933','ariadne.mckinney@gmail.com','22-JAN-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Seymour','Kirby',4200,10,'SRVC','0789661896','kirby.seymour@gmail.com','28-NOV-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Allman','Dante',5200,10,'ADMN','0706519922','dante.allman@gmail.com','25-APR-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rowe','Dollie',3600,10,'MCNC','0715390837','dollie.rowe@gmail.com','25-OCT-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Avalos','Zachery',5100,10,'MCNC','0795572913','zachery.avalos@gmail.com','12-NOV-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Sweeney','Akeem',4200,10,'DRSR','0745471155','akeem.sweeney@gmail.com','7-JAN-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Aguilar','Ty',3800,10,'DRSR','0769088516','ty.aguilar@gmail.com','22-JUL-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Pollard','Demi-Leigh',6200,10,'REL_EXT','0706597437','demi-leigh.pollard@gmail.com','27-JUL-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Trujillo','Clark',4300,10,'CNTBL','0758452421','clark.trujillo@gmail.com','22-JUN-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Sharpe','Tarik',5900,10,'GHD','0716594745','tarik.sharpe@gmail.com','27-AUG-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Gonzales','Kailan',4400,10,'GHD','0748737179','kailan.gonzales@gmail.com','21-NOV-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mcdowell','Jaye',8500,10,'VTRNR','0714343949','jaye.mcdowell@gmail.com','7-DEC-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Blackburn','Renesmae',6200,10,'VTRNR','0799922255','renesmae.blackburn@gmail.com','9-OCT-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cannon','Eduardo',4400,10,'VANZ_PROD','0713313744','eduardo.cannon@gmail.com','28-JUN-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Alcock','Lincoln',3700,10,'VANZ_PROD','0759898352','lincoln.alcock@gmail.com','12-MAY-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Golden','Zavier',4900,10,'INGRJ','0749324856','zavier.golden@gmail.com','15-NOV-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hansen','Haydn',5200,10,'INGRJ','0730062350','haydn.hansen@gmail.com','19-JAN-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Wolf','Ivo',3400,10,'INGRJ','0778431412','ivo.wolf@gmail.com','26-JUL-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mansell','Abby',1900,11,'SRVC','0713918621','abby.mansell@gmail.com','27-AUG-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Campos','Rickie',2800,11,'SRVC','0768204639','rickie.campos@gmail.com','24-AUG-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Novak','Oliver',4100,11,'SRVC','0744568150','oliver.novak@gmail.com','9-SEP-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Marks','Lacie',10100,11,'ADMN','0758867490','lacie.marks@gmail.com','7-MAR-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rawlings','Finnian',5600,11,'MCNC','0739640683','finnian.rawlings@gmail.com','9-OCT-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Plummer','Nawal',5900,11,'MCNC','0730185301','nawal.plummer@gmail.com','9-OCT-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Butt','Nichola',5300,11,'DRSR','0787877695','nichola.butt@gmail.com','14-NOV-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Noel','Cecil',2900,11,'DRSR','0713851589','cecil.noel@gmail.com','17-FEB-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Braun','Emily-Jane',3500,11,'REL_EXT','0771756689','emily-jane.braun@gmail.com','28-MAR-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rutledge','Jacques',2800,11,'CNTBL','0778718492','jacques.rutledge@gmail.com','5-JUN-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bender','Kiri',5800,11,'GHD','0773515687','kiri.bender@gmail.com','25-DEC-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Sloan','Sama',6600,11,'GHD','0738842216','sama.sloan@gmail.com','8-JUL-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ahmad','Karl',6900,11,'VTRNR','0762918707','karl.ahmad@gmail.com','4-OCT-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Draper','Farhana',8300,11,'VTRNR','0700275493','farhana.draper@gmail.com','15-NOV-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Villanueva','Evan',4100,11,'VANZ_PROD','0733420556','evan.villanueva@gmail.com','2-DEC-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Eastwood','Tiah',1500,11,'VANZ_PROD','0719743192','tiah.eastwood@gmail.com','27-OCT-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rangel','Darlene',6100,11,'INGRJ','0714327133','darlene.rangel@gmail.com','8-JUL-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Dowling','Cory',4500,11,'INGRJ','0727761209','cory.dowling@gmail.com','2-AUG-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mackay','Gabrielle',6100,11,'INGRJ','0779882104','gabrielle.mackay@gmail.com','26-DEC-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Wolf','Jayne',3600,12,'SRVC','0783641309','jayne.wolf@gmail.com','6-NOV-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Oakley','Maximus',2700,12,'SRVC','0792475750','maximus.oakley@gmail.com','6-JAN-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Duffy','John-James',1800,12,'SRVC','0703652999','john-james.duffy@gmail.com','27-DEC-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Stanley','Avi',8400,12,'ADMN','0738408250','avi.stanley@gmail.com','1-SEP-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Appleton','Denise',5400,12,'MCNC','0707835745','denise.appleton@gmail.com','21-JAN-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Dickerson','Elliot',5500,12,'MCNC','0790276729','elliot.dickerson@gmail.com','22-JUL-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lowery','Andre',5700,12,'DRSR','0701116778','andre.lowery@gmail.com','19-APR-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Michael','Terrence',3400,12,'DRSR','0716784529','terrence.michael@gmail.com','1-DEC-2015');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Potter','Libby',4000,12,'REL_EXT','0759028395','libby.potter@gmail.com','3-DEC-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Buxton','Alyssia',3200,12,'CNTBL','0780481389','alyssia.buxton@gmail.com','4-JAN-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rasmussen','Kasey',6300,12,'GHD','0783395915','kasey.rasmussen@gmail.com','26-JUN-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Allison','Melissa',5100,12,'GHD','0702644159','melissa.allison@gmail.com','17-JUL-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Andrew','Ibraheem',9200,12,'VTRNR','0772215941','ibraheem.andrew@gmail.com','25-JAN-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Fulton','Lucien',6700,12,'VTRNR','0788047213','lucien.fulton@gmail.com','24-OCT-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Krueger','Nina',1100,12,'VANZ_PROD','0797020517','nina.krueger@gmail.com','1-NOV-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cortez','Isla',3800,12,'VANZ_PROD','0775369634','isla.cortez@gmail.com','3-FEB-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Seymour','Shakira',5000,12,'INGRJ','0796613369','shakira.seymour@gmail.com','3-AUG-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Livingston','Yasmin',3900,12,'INGRJ','0774712250','yasmin.livingston@gmail.com','9-MAR-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mercado','Liana',5200,12,'INGRJ','0788568029','liana.mercado@gmail.com','20-JUL-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mansell','Herbie',3600,13,'SRVC','0757043521','herbie.mansell@gmail.com','1-JUL-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Saunders','Katarina',3600,13,'SRVC','0766165505','katarina.saunders@gmail.com','9-SEP-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Reid','Justin',2800,13,'SRVC','0716190641','justin.reid@gmail.com','8-FEB-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Alston','Stella',6800,13,'ADMN','0744628059','stella.alston@gmail.com','11-DEC-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Moon','Nazim',5100,13,'MCNC','0758467474','nazim.moon@gmail.com','12-JUN-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Whitaker','Mahira',5400,13,'MCNC','0708012389','mahira.whitaker@gmail.com','27-OCT-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Daugherty','Myah',3000,13,'DRSR','0767311800','myah.daugherty@gmail.com','5-MAY-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mair','Naseem',3200,13,'DRSR','0735472377','naseem.mair@gmail.com','1-APR-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mcfarland','Kavan',5200,13,'REL_EXT','0760350606','kavan.mcfarland@gmail.com','21-MAY-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lloyd','Dominykas',5200,13,'CNTBL','0756976053','dominykas.lloyd@gmail.com','24-JAN-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Compton','Sophie',3800,13,'GHD','0736495393','sophie.compton@gmail.com','4-SEP-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Trevino','Mayson',4900,13,'GHD','0776423362','mayson.trevino@gmail.com','4-APR-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Shah','Kia',5500,13,'VTRNR','0750539017','kia.shah@gmail.com','27-MAY-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Morse','Eddison',7900,13,'VTRNR','0738562853','eddison.morse@gmail.com','24-MAY-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Curtis','Kacie',1100,13,'VANZ_PROD','0738507755','kacie.curtis@gmail.com','16-FEB-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Watson','Amanda',2600,13,'VANZ_PROD','0762489812','amanda.watson@gmail.com','16-SEP-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Blankenship','Faraz',6200,13,'INGRJ','0739948666','faraz.blankenship@gmail.com','16-AUG-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Carney','Raymond',4800,13,'INGRJ','0722720488','raymond.carney@gmail.com','27-APR-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Person','Jolie',3300,13,'INGRJ','0726967673','jolie.person@gmail.com','9-APR-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hewitt','Nafisa',2200,14,'SRVC','0741494341','nafisa.hewitt@gmail.com','27-OCT-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Woodley','Margot',3700,14,'SRVC','0799373187','margot.woodley@gmail.com','14-JAN-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Gay','Mahira',4200,14,'SRVC','0742781224','mahira.gay@gmail.com','22-MAY-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Blackmore','Katerina',6700,14,'ADMN','0755076738','katerina.blackmore@gmail.com','10-JAN-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Redman','Yasmine',5700,14,'MCNC','0723623848','yasmine.redman@gmail.com','10-AUG-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Montoya','Khadijah',3600,14,'MCNC','0757585356','khadijah.montoya@gmail.com','3-NOV-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Terrell','Esha',4200,14,'DRSR','0796637278','esha.terrell@gmail.com','7-SEP-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Howard','Dawn',4700,14,'DRSR','0706106003','dawn.howard@gmail.com','16-FEB-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Franco','Rebekka',5800,14,'REL_EXT','0739505010','rebekka.franco@gmail.com','26-MAY-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Nichols','Hawwa',5200,14,'CNTBL','0771538581','hawwa.nichols@gmail.com','4-DEC-2016');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Mcgowan','Lana',5500,14,'GHD','0711446982','lana.mcgowan@gmail.com','3-OCT-2012');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Doherty','Keisha',3400,14,'GHD','0725253495','keisha.doherty@gmail.com','26-OCT-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Hester','Antonia',8800,14,'VTRNR','0772865576','antonia.hester@gmail.com','7-JUL-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Espinoza','Mohammod',8300,14,'VTRNR','0715676056','mohammod.espinoza@gmail.com','26-AUG-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rangel','Brooklyn',2800,14,'VANZ_PROD','0746869518','brooklyn.rangel@gmail.com','4-JAN-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Clarkson','Andre',4400,14,'VANZ_PROD','0781681741','andre.clarkson@gmail.com','28-JUL-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Redmond','Isla',5900,14,'INGRJ','0764776712','isla.redmond@gmail.com','19-JUL-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rivas','Pixie',4000,14,'INGRJ','0728245951','pixie.rivas@gmail.com','1-MAR-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Bellamy','Emmy',2500,14,'INGRJ','0763488833','emmy.bellamy@gmail.com','18-JAN-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lacey','Paloma',4200,12,'SRVC','0740449909','paloma.lacey@gmail.com','14-AUG-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'James','Aaran',1900,7,'SRVC','0709844485','aaran.james@gmail.com','25-JUN-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Frank','Priscilla',3400,2,'SRVC','0773776909','priscilla.frank@gmail.com','9-SEP-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ryan','Emanuel',11700,9,'ADMN','0773981495','emanuel.ryan@gmail.com','16-NOV-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Greig','Denny',6200,5,'MCNC','0740908349','denny.greig@gmail.com','12-MAR-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Buxton','Mahad',5100,3,'MCNC','0719551557','mahad.buxton@gmail.com','8-SEP-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Medina','Tommie',4600,8,'DRSR','0707544401','tommie.medina@gmail.com','21-JUN-2006');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Regan','Percy',5400,3,'DRSR','0749358178','percy.regan@gmail.com','14-DEC-2014');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Rhodes','Can',7400,14,'REL_EXT','0788344128','can.rhodes@gmail.com','21-FEB-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Moreno','Susanna',3600,5,'CNTBL','0748146670','susanna.moreno@gmail.com','17-APR-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Wiley','Joel',6800,5,'GHD','0733383895','joel.wiley@gmail.com','21-SEP-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Callaghan','Cerys',6500,8,'GHD','0726138614','cerys.callaghan@gmail.com','12-JUN-2008');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Novak','Corban',6200,5,'VTRNR','0722957581','corban.novak@gmail.com','24-MAY-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Lindsey','Aneesah',4700,6,'VTRNR','0764427194','aneesah.lindsey@gmail.com','25-OCT-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ellison','Awais',1400,9,'VANZ_PROD','0791198296','awais.ellison@gmail.com','7-NOV-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Fowler','Jonah',4900,6,'VANZ_PROD','0711666843','jonah.fowler@gmail.com','27-MAY-2013');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Fuentes','Hector',3000,13,'INGRJ','0709288047','hector.fuentes@gmail.com','8-SEP-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Vance','Taliah',5900,9,'INGRJ','0701726157','taliah.vance@gmail.com','11-APR-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Cherry','Clara',2900,11,'INGRJ','0713477247','clara.cherry@gmail.com','3-MAR-2011');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Houghton','Zara',4000,7,'SRVC','0770995262','zara.houghton@gmail.com','7-MAY-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Neville','Joy',1800,1,'SRVC','0752724380','joy.neville@gmail.com','3-SEP-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Harding','Terrence',4400,2,'SRVC','0797837167','terrence.harding@gmail.com','14-AUG-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Larson','Misha',8800,7,'ADMN','0749803245','misha.larson@gmail.com','15-OCT-2019');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Robinson','Huzaifah',5100,2,'MCNC','0705226763','huzaifah.robinson@gmail.com','4-APR-2004');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Boyd','Salim',5800,4,'MCNC','0760359455','salim.boyd@gmail.com','23-SEP-2002');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Kennedy','Claire',4500,13,'DRSR','0717508989','claire.kennedy@gmail.com','21-JAN-2018');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Wu','Jennifer',4800,6,'DRSR','0794682286','jennifer.wu@gmail.com','13-MAY-2009');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Clifford','Camille',5500,14,'REL_EXT','0766912024','camille.clifford@gmail.com','23-DEC-2003');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Oakley','Kiri',3700,11,'CNTBL','0712538137','kiri.oakley@gmail.com','19-JUL-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ibarra','Luci',6300,11,'GHD','0715526480','luci.ibarra@gmail.com','20-SEP-2000');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Whitney','Evalyn',6600,10,'GHD','0763723079','evalyn.whitney@gmail.com','10-DEC-2010');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Portillo','Sia',8500,12,'VTRNR','0794330452','sia.portillo@gmail.com','13-OCT-2017');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Zhang','Loren',4100,12,'VTRNR','0795680693','loren.zhang@gmail.com','13-JUL-2007');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Finley','Miranda',4100,13,'VANZ_PROD','0700260902','miranda.finley@gmail.com','21-OCT-2001');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Ryder','Mamie',2000,1,'VANZ_PROD','0736359302','mamie.ryder@gmail.com','9-JUN-2020');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Martinez','Caine',4500,9,'INGRJ','0792263969','caine.martinez@gmail.com','9-FEB-2005');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Donnelly','Jun',3100,5,'INGRJ','0785666366','jun.donnelly@gmail.com','7-OCT-2021');

insert into ANGAJATI(id_ang,nume,prenume,salariu,id_zoo,id_job,nr_tel,email,data_ang)
values (secv_angajat.nextval,'Peterson','Agata',3500,10,'INGRJ','0709211793','agata.peterson@gmail.com','9-MAY-2015');


--inseram inregistrari in SPECIE
insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('TIG_SIB','Carnivor','Portocaliu cu dungi negre','Crepuscular','10','Mamifer','Tigru Siberian');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('TIG_ALB','Carnivor','Alb cu dungi negre','Crepuscular','11','Mamifer','Tigru Bengalez Alb');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('ACV_COD','Carnivor','Maro cu gat alb','Diurn','42','Pasare','Acvila Codalb');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('ALP','Erbivor','Maro inchis','Diurn','20','Mamifer','Alpaca');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('ANA_V','Carnivor','Verde','Nocturn','30','Reptila','Anaconda Verde');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('BRSC_D','Carnivor','Galben cu negru','Diurn','15','Amfibian','Broasca Dungata Galbena');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('URS_BR','Omnivor','Maro','Crepuscular','35','Mamifer','Urs Brun');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('CAP_EU','Erbivor','Maro deschis','Diurn','15','Mamifer','Caprior European');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('TES_APA','Carnivor','Carapace neagra','Diurn','26','Reptila','Testoasa de Apa');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('COA','Omnivor','Portocaliu inchis','Diurn','17','Mamifer','Coati');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('LEU','Carnivor','Portocaliu deschis','Nocturn','30','Mamifer','Leu African');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('RAT','Carnivor','Gri','Nocturn','20','Mamifer','Raton');

insert into SPECIE(id_specie, tip_dieta,colorit,tip_animal,varsta_medie,clasificare,nume_specie)
values ('SCO_IMP','Carnivor','Negru','Nocturn','8','Arahnida','Scorpion Imperial');


--inseram inregistrari in ANIMALE
insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Shakeel',0,2,'TES_APA','Calm',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ivy',4,2,'COA','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kaylee',2,2,'RAT','Agresiv',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Shayla',5,12,'TIG_ALB','Infricosat',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Archer',9,5,'SCO_IMP','Infricosat',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Alexandros',10,11,'ALP','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rhianna',8,2,'ACV_COD','Calm',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Emmanuel',11,13,'CAP_EU','Agitat',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ashlea',27,7,'ACV_COD','Lenes',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Neave',14,10,'CAP_EU','Agresiv',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Yasmin',15,5,'BRSC_D','Lenes',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Orlando',17,4,'ALP','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lee',22,6,'RAT','Agresiv',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tarik',9,7,'ALP','Prietenos',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ziggy',9,3,'TES_APA','Agitat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kristy',12,5,'SCO_IMP','Vesel',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Szymon',11,13,'CAP_EU','Infricosat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sameeha',3,9,'BRSC_D','Infricosat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Eesha',16,6,'ANA_V','Agitat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tymon',40,10,'URS_BR','Agitat',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Elspeth',20,2,'ANA_V','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jarod',12,2,'COA','Vesel',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Heidi',19,10,'BRSC_D','Calm',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Yuvaan',8,2,'ALP','Agitat',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Harvir',24,5,'URS_BR','Vesel',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bree',6,13,'LEU','Agitat',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kareena',0,11,'TIG_ALB','Calm',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Benn',18,10,'ACV_COD','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Fraya',6,13,'ALP','Agresiv',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rojin',13,9,'ALP','Calm',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sneha',9,12,'BRSC_D','Vesel',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Karson',27,11,'TES_APA','Calm',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sara',12,5,'CAP_EU','Infricosat',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Briana',15,12,'COA','Infricosat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Julia',3,4,'COA','Agresiv',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Celyn',7,11,'CAP_EU','Agitat',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Isa',14,10,'CAP_EU','Prietenos',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Olli',24,14,'ACV_COD','Calm',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Katarina',18,5,'ALP','Vesel',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Agatha',9,5,'RAT','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Raphael',4,6,'BRSC_D','Agitat',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jordan',17,3,'LEU','Agresiv',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Adriana',9,2,'CAP_EU','Infricosat',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sierra',4,9,'CAP_EU','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Abbie',20,2,'CAP_EU','Agitat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Timur',18,7,'ALP','Calm',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ariya',13,14,'COA','Infricosat',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Alanah',24,11,'ALP','Agitat',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Orion',22,1,'TES_APA','Agresiv',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jaspal',15,13,'TIG_ALB','Prietenos',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Merryn',14,14,'ALP','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Elsie',18,12,'URS_BR','Infricosat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jaden',2,11,'ALP','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jacqueline',38,1,'URS_BR','Lenes',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bronte',18,6,'URS_BR','Lenes',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rose',3,3,'URS_BR','Calm',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Angel',2,9,'TES_APA','Agitat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jemima',15,13,'LEU','Agresiv',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ayub',20,8,'CAP_EU','Agitat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bernard',16,7,'LEU','Vesel',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rhodri',22,9,'RAT','Agresiv',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ernie',29,9,'LEU','Lenes',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Griff',8,12,'LEU','Agitat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Patrick',3,12,'BRSC_D','Agresiv',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ella',28,5,'TES_APA','Agresiv',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kaylee',9,3,'SCO_IMP','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Leopold',12,2,'CAP_EU','Prietenos',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Amirah',3,8,'ANA_V','Agresiv',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kwame',32,14,'LEU','Prietenos',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Martyna',31,14,'URS_BR','Agresiv',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aadam',7,13,'URS_BR','Agitat',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Pranav',0,4,'COA','Agresiv',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Emerson',7,8,'SCO_IMP','Vesel',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Inayah',4,12,'ALP','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jayde',18,1,'BRSC_D','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Zephaniah',1,3,'COA','Agresiv',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jordon',15,5,'ANA_V','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Zohaib',18,2,'CAP_EU','Prietenos',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Marley',6,8,'ALP','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Daryl',18,13,'URS_BR','Prietenos',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Amisha',7,13,'LEU','Calm',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ruari',25,3,'RAT','Infricosat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kirby',14,12,'TES_APA','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sandra',11,11,'CAP_EU','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nataniel',8,5,'CAP_EU','Calm',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Shaan',5,12,'RAT','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Boris',11,9,'URS_BR','Vesel',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hashir',10,7,'RAT','Calm',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jez',19,4,'RAT','Lenes',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aleesha',8,9,'RAT','Agitat',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ifan',15,6,'BRSC_D','Vesel',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Zaara',8,4,'ACV_COD','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Susanna',2,1,'SCO_IMP','Agresiv',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sufyaan',26,3,'TES_APA','Prietenos',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sadia',27,12,'TES_APA','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Finlay',14,8,'ANA_V','Vesel',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Farrell',18,10,'CAP_EU','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Woodrow',11,11,'URS_BR','Agresiv',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Amrita',9,13,'URS_BR','Calm',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aoife',24,12,'RAT','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Dolores',9,1,'TIG_ALB','Calm',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Chad',5,14,'SCO_IMP','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lilia',22,14,'RAT','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Charlize',2,3,'TIG_ALB','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aariz',1,7,'BRSC_D','Infricosat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Liliana',8,11,'ANA_V','Calm',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Izaak',16,10,'BRSC_D','Agresiv',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mylah',1,7,'TES_APA','Infricosat',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Vicky',18,12,'RAT','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kristy',19,5,'CAP_EU','Lenes',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sommer',34,1,'LEU','Agresiv',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sabiha',8,12,'COA','Lenes',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mercy',17,14,'CAP_EU','Vesel',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Darcy',3,11,'URS_BR','Agresiv',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Wilfred',19,9,'BRSC_D','Lenes',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nichole',27,7,'ANA_V','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jamaal',3,1,'TIG_ALB','Prietenos',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rosanna',9,7,'ALP','Vesel',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kimberley',6,14,'BRSC_D','Agresiv',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rueben',16,2,'TES_APA','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Phillippa',36,1,'URS_BR','Prietenos',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Edna',16,7,'TIG_ALB','Agitat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bevan',6,3,'RAT','Agitat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Priyanka',14,8,'BRSC_D','Agresiv',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Suraj',16,1,'TIG_ALB','Prietenos',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ayrton',19,13,'COA','Agresiv',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Earl',14,12,'ACV_COD','Infricosat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Gabrielius',0,4,'RAT','Lenes',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Adeeb',6,7,'BRSC_D','Vesel',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jaiden',23,9,'ALP','Calm',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kaydan',18,9,'BRSC_D','Vesel',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ieuan',8,7,'COA','Infricosat',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Firat',22,11,'COA','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Anum',19,2,'CAP_EU','Agresiv',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hana',17,11,'URS_BR','Prietenos',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Leigh',19,4,'RAT','Vesel',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ephraim',27,11,'LEU','Lenes',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Emmeline',32,8,'URS_BR','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Danniella',16,9,'CAP_EU','Vesel',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'April',14,14,'TES_APA','Infricosat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rico',1,4,'RAT','Prietenos',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rami',2,10,'LEU','Prietenos',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ember',13,14,'LEU','Infricosat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Akeem',0,5,'TIG_ALB','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Vinay',10,14,'TIG_ALB','Lenes',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mekhi',18,13,'RAT','Infricosat',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Shelbie',1,10,'CAP_EU','Agresiv',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ahmet',10,4,'RAT','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Danyal',20,7,'ALP','Calm',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Archer',10,6,'COA','Agitat',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mario',24,13,'ALP','Calm',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Adele',10,5,'ALP','Calm',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Katherine',36,13,'URS_BR','Agitat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Robyn',20,13,'RAT','Infricosat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Dilan',7,6,'TES_APA','Infricosat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kenzie',38,13,'ACV_COD','Agresiv',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jerry',9,1,'URS_BR','Infricosat',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Glyn',19,2,'RAT','Vesel',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Teo',20,5,'COA','Infricosat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Makenzie',29,7,'ACV_COD','Vesel',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rosanna',16,9,'RAT','Agresiv',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Reo',24,14,'ANA_V','Prietenos',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Humairaa',9,4,'RAT','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Logan',17,11,'BRSC_D','Prietenos',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Conna',34,4,'ANA_V','Agitat',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rome',7,3,'SCO_IMP','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bobby',11,8,'TIG_ALB','Lenes',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Arla',5,9,'BRSC_D','Lenes',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Walid',27,10,'LEU','Infricosat',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lillie',7,7,'SCO_IMP','Prietenos',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Naveed',1,13,'ALP','Agitat',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Thelma',10,9,'SCO_IMP','Calm',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bilal',13,6,'BRSC_D','Agresiv',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Elspeth',8,9,'COA','Infricosat',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Brennan',12,8,'TIG_ALB','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jarod',22,4,'COA','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kayan',4,8,'CAP_EU','Lenes',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Flora',1,2,'URS_BR','Lenes',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rubie',8,14,'SCO_IMP','Lenes',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Finnlay',19,11,'URS_BR','Agitat',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Josh',7,3,'RAT','Calm',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Seb',40,9,'ACV_COD','Infricosat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lilianna',5,12,'TIG_ALB','Infricosat',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Maxine',19,5,'COA','Vesel',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hiba',8,3,'TIG_ALB','Vesel',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aoife',16,3,'TIG_ALB','Lenes',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rudy',8,4,'CAP_EU','Vesel',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lilith',2,12,'SCO_IMP','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Luther',4,14,'CAP_EU','Agresiv',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Elaine',3,10,'SCO_IMP','Calm',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Liam',5,11,'SCO_IMP','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kornelia',23,2,'LEU','Vesel',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Layla',16,9,'COA','Agitat',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Marie',4,11,'ANA_V','Agitat',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Malika',4,11,'TIG_ALB','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jace',3,7,'LEU','Agresiv',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Khalid',13,6,'COA','Vesel',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Amman',18,11,'CAP_EU','Prietenos',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Celyn',12,1,'SCO_IMP','Lenes',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bibi',17,9,'LEU','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Arthur',8,5,'TIG_ALB','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Zeeshan',30,12,'LEU','Agresiv',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'John',14,9,'COA','Prietenos',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tasha',3,5,'RAT','Prietenos',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bruno',16,11,'COA','Prietenos',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Farhaan',4,9,'TIG_ALB','Vesel',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Corinne',15,11,'ACV_COD','Prietenos',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Siya',11,2,'CAP_EU','Calm',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kerri',7,11,'TIG_ALB','Vesel',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rebekka',14,9,'BRSC_D','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kalum',14,6,'CAP_EU','Agresiv',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Fynley',14,9,'TES_APA','Calm',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Abbigail',24,6,'ANA_V','Agresiv',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tiernan',12,1,'LEU','Agitat',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Corban',12,10,'TES_APA','Infricosat',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kristen',21,10,'COA','Vesel',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Emer',24,9,'TES_APA','Agresiv',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Yasmin',15,2,'COA','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tyrone',31,6,'TES_APA','Prietenos',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Keaton',10,1,'TIG_ALB','Prietenos',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Haider',10,13,'COA','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Malcolm',31,7,'TES_APA','Agresiv',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lexi',4,8,'COA','Prietenos',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mathilda',6,3,'SCO_IMP','Infricosat',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aine',3,9,'URS_BR','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Pierce',24,8,'URS_BR','Agresiv',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ayse',4,13,'BRSC_D','Prietenos',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aarav',7,11,'SCO_IMP','Vesel',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Dione',15,7,'BRSC_D','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Daniyal',22,9,'LEU','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jane',28,14,'TES_APA','Calm',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sonia',19,1,'COA','Lenes',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Yisroel',35,3,'LEU','Prietenos',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ewen',18,8,'ANA_V','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Chace',28,6,'URS_BR','Calm',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nuha',5,8,'SCO_IMP','Calm',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Layla',21,12,'ANA_V','Agresiv',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kurtis',10,13,'URS_BR','Infricosat',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jorden',18,1,'BRSC_D','Agresiv',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Vikki',4,12,'COA','Infricosat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Riaz',4,2,'TES_APA','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bernard',19,10,'COA','Lenes',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Storm',15,3,'BRSC_D','Prietenos',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kobi',2,11,'RAT','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Matei',7,12,'BRSC_D','Calm',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Callum',12,14,'CAP_EU','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Matilda',8,1,'TES_APA','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mahek',32,14,'URS_BR','Agresiv',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nikolas',8,12,'ANA_V','Agitat',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Dylon',15,9,'BRSC_D','Calm',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Loki',5,8,'CAP_EU','Infricosat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Haroon',7,12,'TES_APA','Agresiv',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Zubair',25,12,'TES_APA','Lenes',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nadeem',19,12,'URS_BR','Prietenos',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Precious',8,9,'URS_BR','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Maisey',17,4,'COA','Vesel',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Alby',26,9,'URS_BR','Agitat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Clay',20,5,'TES_APA','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kay',15,9,'ANA_V','Vesel',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hammad',5,8,'RAT','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Stevie',6,10,'BRSC_D','Agresiv',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Cassius',26,8,'ANA_V','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Janelle',11,11,'TIG_ALB','Vesel',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ioan',27,12,'ANA_V','Agresiv',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Reanne',4,8,'TIG_ALB','Prietenos',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Olivia',6,10,'BRSC_D','Agresiv',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ehsan',1,1,'CAP_EU','Calm',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rylan',8,6,'CAP_EU','Agresiv',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kyla',2,1,'RAT','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Cassandra',24,5,'TES_APA','Infricosat',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hadiqa',13,5,'BRSC_D','Vesel',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Eleasha',32,5,'ANA_V','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Daniela',7,13,'ALP','Vesel',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Farrell',29,7,'ANA_V','Prietenos',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Vickie',10,12,'CAP_EU','Prietenos',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sioned',29,9,'ACV_COD','Calm',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Benjamin',13,6,'COA','Vesel',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Marianne',17,5,'TES_APA','Vesel',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ayman',8,3,'URS_BR','Agresiv',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Subhaan',19,5,'ALP','Infricosat',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Teejay',8,12,'TIG_ALB','Agitat',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hasnain',29,8,'ANA_V','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lyndsey',16,10,'BRSC_D','Lenes',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mason',8,7,'SCO_IMP','Infricosat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Joan',7,11,'RAT','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kiah',1,8,'TIG_ALB','Agitat',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Saba',12,12,'ALP','Agresiv',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Mairead',8,2,'ANA_V','Prietenos',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jazmine',9,5,'SCO_IMP','Calm',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Jeffrey',33,13,'ANA_V','Lenes',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Neave',3,10,'LEU','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Lorena',2,14,'LEU','Prietenos',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Marc',14,5,'CAP_EU','Agitat',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Helin',8,7,'SCO_IMP','Calm',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sammy',5,12,'SCO_IMP','Agitat',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Samual',18,14,'RAT','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Natasha',16,11,'CAP_EU','Calm',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Erin',29,6,'TES_APA','Calm',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tyriq',3,10,'ACV_COD','Prietenos',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tonya',1,13,'BRSC_D','Agitat',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Dani',20,2,'ALP','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hari',0,1,'SCO_IMP','Calm',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rojin',11,1,'BRSC_D','Vesel',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Kirstie',8,3,'BRSC_D','Vesel',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sandra',7,3,'CAP_EU','Calm',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Rudy',1,4,'TES_APA','Agresiv',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Haydon',24,9,'ALP','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Conan',30,14,'LEU','Vesel',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Bibi',3,14,'URS_BR','Calm',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Naomi',26,1,'ACV_COD','Calm',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ammar',7,7,'LEU','Agitat',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Cerys',21,6,'TES_APA','Prietenos',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Aditya',6,3,'URS_BR','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Seth',6,13,'ANA_V','Calm',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Haleema',4,2,'SCO_IMP','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Campbell',33,2,'LEU','Lenes',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sarah',10,13,'CAP_EU','Lenes',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Teri',1,11,'URS_BR','Lenes',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Salim',3,10,'ANA_V','Infricosat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Gurveer',13,14,'ANA_V','Lenes',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Dimitri',13,6,'BRSC_D','Prietenos',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Elif',13,2,'SCO_IMP','Infricosat',11);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Camille',0,11,'URS_BR','Agresiv',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Clarke',2,9,'COA','Prietenos',8);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ellesha',9,14,'RAT','Calm',9);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Brenna',8,12,'ANA_V','Vesel',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Ami',32,9,'ANA_V','Agresiv',7);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nichole',45,1,'ACV_COD','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Scarlett',19,3,'COA','Agresiv',6);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Marius',5,2,'TIG_ALB','Agitat',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Tiernan',2,12,'SCO_IMP','Lenes',3);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Shannan',6,2,'LEU','Vesel',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Martin',17,6,'RAT','Lenes',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Sarah',15,2,'ALP','Prietenos',2);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Connagh',23,10,'LEU','Vesel',1);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Max',24,12,'LEU','Prietenos',10);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Nancie',10,1,'URS_BR','Lenes',5);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Eamon',23,8,'LEU','Infricosat',0);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Hallie',6,2,'TIG_ALB','Agresiv',4);

insert into ANIMALE(id_animal,nume,varsta,id_zoo,id_specie,temperament,varsta_luni)
values(secv_animale.nextval,'Elliott',21,5,'ANA_V','Prietenos',8);


--inseram inregistrari in TIP_RESTRICTIE
insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('REP_US','Repaus Usor','Repaus usor pentru reducerea oboselii');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('REP_MED','Repaus Medical','Repaus pentru imbunatatirea starii animalului');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('INT_HR','Interzicere Hrana ','Interzicere la hrana pentru imbunatatirea starii animalului');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('EVI_FUR','Evitare Furaje','Evitarea hranirii cu furaje');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('HR_ML','Hrana Moale','Hranirea se va face cu hrana moale');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('IZO','Izolare','Izolare pentru a se recupera');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('GUL','Guler Medical','Guler pentru a nu putea ajunge la rani');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('EVI_RO','Evitare Rosie','Evitare carne rosie');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('INT_CUP_FEM','Interzicere Cuplare','Interzicere cuplare cu femele in adapost');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('INT_CUP_MASC','Interzicere Cuplare','Interzicere cuplare cu masculi in adapost');

insert into TIP_RESTRICTIE(tip_restrictie,nume_restrictie,descriere_restrictie)
values('INT_CUP_P','Interzicere Cuplare','Interzicere cuplare cu pui in adapost');


--inseram inregistrari in RESTRICTIE
insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'6-MAY-2021','14-SEP-2023',275,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'3-FEB-2019','27-JUL-2019',308,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'10-APR-2013','21-JUL-2013',354,'INT_HR');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'15-JUN-2008','23-JUN-2011',397,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'14-NOV-2016','20-DEC-2019',213,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'21-JAN-2001','5-DEC-2001',241,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'22-MAR-2004','12-NOV-2006',305,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-OCT-2014','22-DEC-2015',342,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'14-JAN-2019','15-MAR-2022',162,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'4-FEB-2013','21-SEP-2016',345,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'26-JUL-2010','28-JUL-2012',235,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'27-MAR-2005','9-MAY-2007',127,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'20-OCT-2007','21-OCT-2007',165,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'16-FEB-2002','13-NOV-2003',380,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'13-DEC-2017','16-DEC-2020',375,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'11-JAN-2016','14-FEB-2016',164,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'27-APR-2012','25-JUL-2014',385,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'27-JUN-2011','18-NOV-2014',141,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'23-JUL-2011','20-NOV-2013',415,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'19-JUN-2014','1-NOV-2015',428,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'26-AUG-2010','24-OCT-2011',116,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'27-DEC-2005','27-DEC-2006',320,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-FEB-2006','15-NOV-2007',435,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'23-JUL-2013','12-OCT-2014',194,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'6-NOV-2003','5-DEC-2006',165,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-JUL-2007','16-NOV-2009',330,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'6-NOV-2013','28-DEC-2013',396,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'3-JUL-2016','23-SEP-2016',266,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'5-JUN-2003','16-AUG-2004',388,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'15-MAY-2008','18-AUG-2008',247,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'21-MAR-2000','23-OCT-2002',372,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'10-JUN-2009','26-JUL-2010',173,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'16-AUG-2005','23-NOV-2006',265,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-FEB-2012','10-MAY-2012',189,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'19-AUG-2010','24-AUG-2011',344,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'9-DEC-2000','10-DEC-2001',185,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'17-OCT-2018','13-DEC-2018',359,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'8-AUG-2012','11-NOV-2015',380,'EVI_RO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'19-AUG-2002','28-AUG-2005',255,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'11-APR-2015','14-NOV-2018',336,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'26-DEC-2017','26-DEC-2017',113,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'3-MAR-2021','6-JUL-2023',148,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'5-JUL-2020','28-OCT-2020',100,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'27-DEC-2018','27-DEC-2020',335,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'14-JUN-2007','3-DEC-2009',163,'INT_HR');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-JUL-2011','28-JUL-2011',294,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-APR-2018','3-AUG-2018',339,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'14-MAY-2007','28-AUG-2009',438,'EVI_RO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'24-NOV-2001','24-NOV-2001',207,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'13-SEP-2015','15-NOV-2018',286,'INT_HR');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'6-JUL-2006','21-NOV-2006',230,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'2-JAN-2015','7-JUN-2018',417,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'10-JUN-2001','23-JUL-2003',375,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'20-OCT-2010','19-NOV-2012',378,'EVI_RO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'24-JAN-2019','5-MAY-2020',314,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'2-SEP-2016','15-NOV-2016',183,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'19-JUL-2011','24-JUL-2012',100,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'18-AUG-2003','24-AUG-2004',151,'EVI_RO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'7-SEP-2008','18-SEP-2010',331,'EVI_RO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'20-MAY-2004','23-JUL-2006',238,'REP_MED');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'25-DEC-2008','27-DEC-2008',147,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'3-JUN-2006','22-AUG-2007',216,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'26-AUG-2012','19-SEP-2015',346,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'24-MAY-2002','11-OCT-2005',372,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-APR-2014','23-JUN-2014',194,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'22-FEB-2006','5-JUL-2007',419,'REP_MED');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'17-JUN-2010','12-DEC-2013',342,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'23-FEB-2021','6-APR-2023',161,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'9-DEC-2016','23-DEC-2018',333,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'1-JUL-2018','7-OCT-2021',347,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'18-FEB-2020','28-APR-2020',105,'REP_MED');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-JAN-2009','12-DEC-2009',309,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'2-JUN-2014','8-AUG-2017',292,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'14-JAN-2003','2-DEC-2003',172,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-APR-2008','16-NOV-2008',431,'INT_HR');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'22-OCT-2015','28-OCT-2016',221,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-OCT-2018','24-NOV-2020',165,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'24-SEP-2018','3-DEC-2020',212,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'18-MAR-2021','21-JUN-2021',176,'INT_HR');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'10-MAR-2002','20-JUL-2003',151,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'18-FEB-2021','16-SEP-2022',213,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'9-JUN-2019','17-AUG-2019',340,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'23-MAR-2018','14-NOV-2018',159,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-MAY-2009','12-AUG-2012',277,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'5-OCT-2017','4-DEC-2020',226,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'21-APR-2004','28-SEP-2007',273,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'23-NOV-2013','25-NOV-2015',196,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'2-APR-2008','6-NOV-2008',110,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'9-FEB-2011','1-SEP-2011',296,'INT_CUP_P');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'2-OCT-2006','24-NOV-2008',162,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'1-OCT-2002','27-DEC-2004',278,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'7-FEB-2008','11-AUG-2008',335,'IZO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'26-OCT-2007','28-OCT-2009',164,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'23-FEB-2013','10-SEP-2016',324,'GUL');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'28-AUG-2017','23-DEC-2017',225,'HR_ML');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'13-SEP-2006','4-DEC-2009',345,'REP_MED');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'2-JUL-2012','24-JUL-2014',136,'EVI_FUR');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'25-JUL-2002','13-AUG-2004',339,'EVI_RO');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'20-JUL-2018','1-SEP-2021',356,'INT_CUP_FEM');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'7-MAY-2004','18-OCT-2006',393,'INT_CUP_MASC');

insert into RESTRICTIE(id_restrictie,data_inceput,data_sfarsit,id_animal,tip_restrictie)
values(secv_restrictie.nextval,'15-NOV-2005','17-DEC-2006',148,'INT_CUP_P');

--inseram inregistrari in TIP_HRANA
insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('MRCV_FR','Morcovi','Franta',1);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('MRCV_IT','Morcovi','Italia',2);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('FUR_GER','Furaje','Germania',5);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('SAL_AUS','SALATA','Austria',1);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('SEM_RO','Seminte','Romania',10);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('CRNV_CH','Carne Vita','China',1);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('CRNO_US','Carne Oaie','USA',2);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('INS_IN','Insecte','India',7);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('PST_BUG','Peste','Bulgaria',3);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('CER_SP','Cereale','Spania',15);

insert into TIP_HRANA(id_tip_hrana,nume_hrana,origine,sapt_valabilitate)
values('POR_CAN','Porumb','Canada',16);


--inseram inregistrari in HRANA
insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,430,1,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,890,1,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,20,1,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,450,1,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,580,1,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,440,1,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,260,1,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,180,1,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,980,1,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,810,1,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,110,2,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,690,2,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,730,2,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,1000,2,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,560,2,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,950,2,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,820,2,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,110,2,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,700,2,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,20,2,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,60,3,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,790,3,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,60,3,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,170,3,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,160,3,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,40,3,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,360,3,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,940,3,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,460,3,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,500,3,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,610,4,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,620,4,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,70,4,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,930,4,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,30,4,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,930,4,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,320,4,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,150,4,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,420,4,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,960,4,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,490,5,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,590,5,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,350,5,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,300,5,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,780,5,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,820,5,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,80,5,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,880,5,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,900,5,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,360,5,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,190,6,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,530,6,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,490,6,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,420,6,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,730,6,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,460,6,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,740,6,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,230,6,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,330,6,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,240,6,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,260,7,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,480,7,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,660,7,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,350,7,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,260,7,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,300,7,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,720,7,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,690,7,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,470,7,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,70,7,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,450,8,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,500,8,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,480,8,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,970,8,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,530,8,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,350,8,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,930,8,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,1000,8,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,350,8,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,370,8,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,30,9,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,80,9,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,230,9,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,980,9,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,80,9,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,520,9,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,330,9,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,660,9,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,600,9,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,250,9,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,460,10,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,690,10,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,880,10,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,650,10,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,550,10,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,330,10,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,830,10,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,800,10,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,410,10,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,220,10,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,410,11,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,440,11,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,790,11,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,90,11,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,920,11,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,360,11,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,510,11,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,940,11,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,140,11,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,420,11,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,190,12,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,60,12,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,140,12,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,290,12,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,750,12,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,650,12,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,990,12,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,720,12,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,990,12,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,220,12,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,370,13,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,400,13,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,880,13,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,670,13,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,770,13,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,410,13,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,100,13,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,340,13,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,930,13,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,380,13,'SEM_RO');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,580,14,'CER_SP');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,750,14,'CRNO_US');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,250,14,'CRNV_CH');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,540,14,'FUR_GER');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,760,14,'INS_IN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,360,14,'MRCV_IT');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,180,14,'POR_CAN');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,850,14,'PST_BUG');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,530,14,'SAL_AUS');

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(secv_hrana.nextval,940,14,'SEM_RO');


--inseram inregistrari in HRANESTE
insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(148,517,707,'16-MAY-2022',TO_DATE('16-MAY-2022 17:31','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(148,517,707,'16-MAY-2022',TO_DATE('16-MAY-2022 3:8','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(148,517,707,'16-MAY-2022',TO_DATE('16-MAY-2022 4:4','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(153,518,701,'16-MAY-2022',TO_DATE('16-MAY-2022 9:15','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(174,518,704,'16-MAY-2022',TO_DATE('16-MAY-2022 11:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(192,518,704,'16-MAY-2022',TO_DATE('16-MAY-2022 6:43','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(192,500,704,'16-MAY-2022',TO_DATE('16-MAY-2022 23:50','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(192,518,704,'16-MAY-2022',TO_DATE('16-MAY-2022 5:36','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(200,518,701,'16-MAY-2022',TO_DATE('16-MAY-2022 4:33','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(210,516,707,'16-MAY-2022',TO_DATE('16-MAY-2022 13:20','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(216,500,702,'16-MAY-2022',TO_DATE('16-MAY-2022 7:23','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(216,518,702,'16-MAY-2022',TO_DATE('16-MAY-2022 0:35','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(216,518,702,'16-MAY-2022',TO_DATE('16-MAY-2022 22:7','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(220,517,706,'16-MAY-2022',TO_DATE('16-MAY-2022 15:47','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(220,516,702,'16-MAY-2022',TO_DATE('16-MAY-2022 5:15','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(220,516,702,'16-MAY-2022',TO_DATE('16-MAY-2022 3:14','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(224,506,702,'16-MAY-2022',TO_DATE('16-MAY-2022 10:41','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(224,517,701,'16-MAY-2022',TO_DATE('16-MAY-2022 12:30','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(224,517,702,'16-MAY-2022',TO_DATE('16-MAY-2022 9:51','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(256,517,705,'16-MAY-2022',TO_DATE('16-MAY-2022 12:40','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(256,517,700,'16-MAY-2022',TO_DATE('16-MAY-2022 5:16','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(298,518,704,'16-MAY-2022',TO_DATE('16-MAY-2022 19:10','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(313,518,707,'16-MAY-2022',TO_DATE('16-MAY-2022 11:55','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(313,517,702,'16-MAY-2022',TO_DATE('16-MAY-2022 20:50','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(319,500,702,'16-MAY-2022',TO_DATE('16-MAY-2022 7:1','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(319,518,701,'16-MAY-2022',TO_DATE('16-MAY-2022 19:26','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(331,500,701,'16-MAY-2022',TO_DATE('16-MAY-2022 17:42','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(331,518,706,'16-MAY-2022',TO_DATE('16-MAY-2022 2:4','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(338,518,704,'16-MAY-2022',TO_DATE('16-MAY-2022 8:12','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(338,517,704,'16-MAY-2022',TO_DATE('16-MAY-2022 4:49','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(346,500,707,'16-MAY-2022',TO_DATE('16-MAY-2022 22:0','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(346,518,707,'16-MAY-2022',TO_DATE('16-MAY-2022 6:59','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(366,506,706,'16-MAY-2022',TO_DATE('16-MAY-2022 16:51','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(366,517,705,'16-MAY-2022',TO_DATE('16-MAY-2022 3:7','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(366,518,705,'16-MAY-2022',TO_DATE('16-MAY-2022 15:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(368,506,702,'16-MAY-2022',TO_DATE('16-MAY-2022 2:13','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(368,516,702,'16-MAY-2022',TO_DATE('16-MAY-2022 10:45','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(368,518,701,'16-MAY-2022',TO_DATE('16-MAY-2022 19:5','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(401,500,704,'16-MAY-2022',TO_DATE('16-MAY-2022 5:48','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(402,506,704,'16-MAY-2022',TO_DATE('16-MAY-2022 18:13','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(409,500,707,'16-MAY-2022',TO_DATE('16-MAY-2022 8:43','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(409,516,702,'16-MAY-2022',TO_DATE('16-MAY-2022 7:30','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(427,517,701,'16-MAY-2022',TO_DATE('16-MAY-2022 4:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(427,518,702,'16-MAY-2022',TO_DATE('16-MAY-2022 23:19','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(427,518,707,'16-MAY-2022',TO_DATE('16-MAY-2022 14:13','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(436,518,708,'16-MAY-2022',TO_DATE('16-MAY-2022 1:16','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(436,516,700,'16-MAY-2022',TO_DATE('16-MAY-2022 10:41','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(436,516,708,'16-MAY-2022',TO_DATE('16-MAY-2022 21:21','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(100,536,717,'16-MAY-2022',TO_DATE('16-MAY-2022 13:33','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(101,536,718,'16-MAY-2022',TO_DATE('16-MAY-2022 14:0','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(102,536,712,'16-MAY-2022',TO_DATE('16-MAY-2022 11:0','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(102,535,711,'16-MAY-2022',TO_DATE('16-MAY-2022 8:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(102,536,711,'16-MAY-2022',TO_DATE('16-MAY-2022 15:22','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(106,786,717,'16-MAY-2022',TO_DATE('16-MAY-2022 13:5','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(106,535,711,'16-MAY-2022',TO_DATE('16-MAY-2022 3:21','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(120,537,711,'16-MAY-2022',TO_DATE('16-MAY-2022 19:15','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(121,537,713,'16-MAY-2022',TO_DATE('16-MAY-2022 4:41','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(123,535,716,'16-MAY-2022',TO_DATE('16-MAY-2022 0:5','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(123,536,716,'16-MAY-2022',TO_DATE('16-MAY-2022 8:52','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(142,786,713,'16-MAY-2022',TO_DATE('16-MAY-2022 7:55','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(144,536,716,'16-MAY-2022',TO_DATE('16-MAY-2022 12:25','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(144,535,713,'16-MAY-2022',TO_DATE('16-MAY-2022 18:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(166,536,715,'16-MAY-2022',TO_DATE('16-MAY-2022 20:36','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(166,536,716,'16-MAY-2022',TO_DATE('16-MAY-2022 2:39','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(177,535,713,'16-MAY-2022',TO_DATE('16-MAY-2022 16:49','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(219,537,717,'16-MAY-2022',TO_DATE('16-MAY-2022 12:22','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(233,537,715,'16-MAY-2022',TO_DATE('16-MAY-2022 19:34','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(233,536,716,'16-MAY-2022',TO_DATE('16-MAY-2022 18:49','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(257,786,711,'16-MAY-2022',TO_DATE('16-MAY-2022 21:28','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(277,535,713,'16-MAY-2022',TO_DATE('16-MAY-2022 22:55','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(277,535,710,'16-MAY-2022',TO_DATE('16-MAY-2022 20:32','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(291,535,712,'16-MAY-2022',TO_DATE('16-MAY-2022 13:44','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(291,536,711,'16-MAY-2022',TO_DATE('16-MAY-2022 1:4','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(291,788,711,'16-MAY-2022',TO_DATE('16-MAY-2022 8:56','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(307,788,715,'16-MAY-2022',TO_DATE('16-MAY-2022 14:37','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(307,535,715,'16-MAY-2022',TO_DATE('16-MAY-2022 1:7','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(307,537,715,'16-MAY-2022',TO_DATE('16-MAY-2022 23:28','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(317,788,710,'16-MAY-2022',TO_DATE('16-MAY-2022 20:5','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(317,537,718,'16-MAY-2022',TO_DATE('16-MAY-2022 2:16','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(317,537,718,'16-MAY-2022',TO_DATE('16-MAY-2022 12:20','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(340,537,717,'16-MAY-2022',TO_DATE('16-MAY-2022 9:50','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(340,786,717,'16-MAY-2022',TO_DATE('16-MAY-2022 3:47','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(387,536,717,'16-MAY-2022',TO_DATE('16-MAY-2022 4:4','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(387,537,712,'16-MAY-2022',TO_DATE('16-MAY-2022 7:5','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(387,537,712,'16-MAY-2022',TO_DATE('16-MAY-2022 19:22','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(400,788,710,'16-MAY-2022',TO_DATE('16-MAY-2022 20:34','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(400,535,715,'16-MAY-2022',TO_DATE('16-MAY-2022 7:19','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(400,536,715,'16-MAY-2022',TO_DATE('16-MAY-2022 3:33','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(414,536,714,'16-MAY-2022',TO_DATE('16-MAY-2022 18:50','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(414,786,714,'16-MAY-2022',TO_DATE('16-MAY-2022 15:58','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(414,536,714,'16-MAY-2022',TO_DATE('16-MAY-2022 7:47','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(415,786,717,'16-MAY-2022',TO_DATE('16-MAY-2022 11:22','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(415,537,712,'16-MAY-2022',TO_DATE('16-MAY-2022 12:40','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(421,537,714,'16-MAY-2022',TO_DATE('16-MAY-2022 13:43','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(421,536,714,'16-MAY-2022',TO_DATE('16-MAY-2022 5:12','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(421,535,714,'16-MAY-2022',TO_DATE('16-MAY-2022 4:32','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(429,535,717,'16-MAY-2022',TO_DATE('16-MAY-2022 16:35','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(429,536,717,'16-MAY-2022',TO_DATE('16-MAY-2022 17:32','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(429,535,712,'16-MAY-2022',TO_DATE('16-MAY-2022 3:55','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(431,535,717,'16-MAY-2022',TO_DATE('16-MAY-2022 20:29','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(433,536,716,'16-MAY-2022',TO_DATE('16-MAY-2022 13:50','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(433,786,718,'16-MAY-2022',TO_DATE('16-MAY-2022 7:40','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(438,537,717,'16-MAY-2022',TO_DATE('16-MAY-2022 23:32','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(438,537,711,'16-MAY-2022',TO_DATE('16-MAY-2022 1:55','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(438,537,712,'16-MAY-2022',TO_DATE('16-MAY-2022 16:45','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(114,551,727,'16-MAY-2022',TO_DATE('16-MAY-2022 23:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(114,551,727,'16-MAY-2022',TO_DATE('16-MAY-2022 2:18','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(141,554,722,'16-MAY-2022',TO_DATE('16-MAY-2022 15:0','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(155,555,720,'16-MAY-2022',TO_DATE('16-MAY-2022 7:12','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(155,550,722,'16-MAY-2022',TO_DATE('16-MAY-2022 17:31','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(165,550,724,'16-MAY-2022',TO_DATE('16-MAY-2022 15:38','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(165,555,724,'16-MAY-2022',TO_DATE('16-MAY-2022 7:4','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(175,556,722,'16-MAY-2022',TO_DATE('16-MAY-2022 21:51','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(181,556,722,'16-MAY-2022',TO_DATE('16-MAY-2022 20:23','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(181,556,722,'16-MAY-2022',TO_DATE('16-MAY-2022 6:19','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(193,554,727,'16-MAY-2022',TO_DATE('16-MAY-2022 4:18','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(193,554,727,'16-MAY-2022',TO_DATE('16-MAY-2022 2:3','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(193,556,727,'16-MAY-2022',TO_DATE('16-MAY-2022 22:48','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(203,556,722,'16-MAY-2022',TO_DATE('16-MAY-2022 4:0','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(203,550,722,'16-MAY-2022',TO_DATE('16-MAY-2022 7:28','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(203,551,721,'16-MAY-2022',TO_DATE('16-MAY-2022 19:50','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(222,555,722,'16-MAY-2022',TO_DATE('16-MAY-2022 0:38','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(265,550,724,'16-MAY-2022',TO_DATE('16-MAY-2022 4:27','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(265,555,724,'16-MAY-2022',TO_DATE('16-MAY-2022 7:9','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(280,551,721,'16-MAY-2022',TO_DATE('16-MAY-2022 11:59','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(280,555,722,'16-MAY-2022',TO_DATE('16-MAY-2022 18:16','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(284,556,722,'16-MAY-2022',TO_DATE('16-MAY-2022 5:18','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(284,555,722,'16-MAY-2022',TO_DATE('16-MAY-2022 17:22','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(284,554,727,'16-MAY-2022',TO_DATE('16-MAY-2022 23:37','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(285,555,722,'16-MAY-2022',TO_DATE('16-MAY-2022 15:58','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(323,556,724,'16-MAY-2022',TO_DATE('16-MAY-2022 18:22','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(323,554,724,'16-MAY-2022',TO_DATE('16-MAY-2022 2:22','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(323,556,724,'16-MAY-2022',TO_DATE('16-MAY-2022 18:1','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(332,555,727,'16-MAY-2022',TO_DATE('16-MAY-2022 5:44','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(342,550,724,'16-MAY-2022',TO_DATE('16-MAY-2022 7:29','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(342,550,724,'16-MAY-2022',TO_DATE('16-MAY-2022 15:26','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(342,554,724,'16-MAY-2022',TO_DATE('16-MAY-2022 14:9','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(378,554,722,'16-MAY-2022',TO_DATE('16-MAY-2022 23:14','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(403,554,724,'16-MAY-2022',TO_DATE('16-MAY-2022 4:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(403,555,724,'16-MAY-2022',TO_DATE('16-MAY-2022 8:23','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(404,554,726,'16-MAY-2022',TO_DATE('16-MAY-2022 21:25','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(412,556,726,'16-MAY-2022',TO_DATE('16-MAY-2022 9:59','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(412,556,728,'16-MAY-2022',TO_DATE('16-MAY-2022 4:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(428,550,729,'16-MAY-2022',TO_DATE('16-MAY-2022 23:19','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(428,555,722,'16-MAY-2022',TO_DATE('16-MAY-2022 14:26','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(428,551,728,'16-MAY-2022',TO_DATE('16-MAY-2022 2:48','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(111,575,738,'16-MAY-2022',TO_DATE('16-MAY-2022 4:18','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(134,573,739,'16-MAY-2022',TO_DATE('16-MAY-2022 22:20','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(134,572,738,'16-MAY-2022',TO_DATE('16-MAY-2022 7:29','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(134,573,737,'16-MAY-2022',TO_DATE('16-MAY-2022 2:10','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(171,575,733,'16-MAY-2022',TO_DATE('16-MAY-2022 17:38','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(171,573,738,'16-MAY-2022',TO_DATE('16-MAY-2022 14:10','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(188,575,732,'16-MAY-2022',TO_DATE('16-MAY-2022 11:12','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(188,571,732,'16-MAY-2022',TO_DATE('16-MAY-2022 15:51','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(188,574,737,'16-MAY-2022',TO_DATE('16-MAY-2022 9:25','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(191,575,732,'16-MAY-2022',TO_DATE('16-MAY-2022 23:44','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(191,573,732,'16-MAY-2022',TO_DATE('16-MAY-2022 14:51','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(191,574,732,'16-MAY-2022',TO_DATE('16-MAY-2022 3:9','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(227,573,731,'16-MAY-2022',TO_DATE('16-MAY-2022 14:56','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(235,573,731,'16-MAY-2022',TO_DATE('16-MAY-2022 18:36','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(235,573,731,'16-MAY-2022',TO_DATE('16-MAY-2022 10:16','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(235,573,732,'16-MAY-2022',TO_DATE('16-MAY-2022 12:16','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(240,575,737,'16-MAY-2022',TO_DATE('16-MAY-2022 3:4','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(240,571,737,'16-MAY-2022',TO_DATE('16-MAY-2022 4:3','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(240,573,732,'16-MAY-2022',TO_DATE('16-MAY-2022 22:6','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(247,572,737,'16-MAY-2022',TO_DATE('16-MAY-2022 4:54','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(262,574,731,'16-MAY-2022',TO_DATE('16-MAY-2022 16:29','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(264,575,732,'16-MAY-2022',TO_DATE('16-MAY-2022 2:20','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(264,573,737,'16-MAY-2022',TO_DATE('16-MAY-2022 20:31','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(264,573,731,'16-MAY-2022',TO_DATE('16-MAY-2022 5:40','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(275,573,732,'16-MAY-2022',TO_DATE('16-MAY-2022 4:3','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(286,571,736,'16-MAY-2022',TO_DATE('16-MAY-2022 0:40','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(286,574,736,'16-MAY-2022',TO_DATE('16-MAY-2022 17:38','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(355,572,737,'16-MAY-2022',TO_DATE('16-MAY-2022 20:35','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(355,573,731,'16-MAY-2022',TO_DATE('16-MAY-2022 10:6','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(355,572,739,'16-MAY-2022',TO_DATE('16-MAY-2022 16:14','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(405,575,737,'16-MAY-2022',TO_DATE('16-MAY-2022 19:12','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(405,571,737,'16-MAY-2022',TO_DATE('16-MAY-2022 16:28','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(104,777,744,'16-MAY-2022',TO_DATE('16-MAY-2022 3:39','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(104,592,744,'16-MAY-2022',TO_DATE('16-MAY-2022 20:50','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(104,801,744,'16-MAY-2022',TO_DATE('16-MAY-2022 20:9','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(110,592,744,'16-MAY-2022',TO_DATE('16-MAY-2022 20:38','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(110,594,744,'16-MAY-2022',TO_DATE('16-MAY-2022 6:34','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(115,775,744,'16-MAY-2022',TO_DATE('16-MAY-2022 17:10','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(115,593,744,'16-MAY-2022',TO_DATE('16-MAY-2022 18:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(115,594,744,'16-MAY-2022',TO_DATE('16-MAY-2022 16:52','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(124,592,748,'16-MAY-2022',TO_DATE('16-MAY-2022 14:49','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(124,775,743,'16-MAY-2022',TO_DATE('16-MAY-2022 20:35','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(124,769,747,'16-MAY-2022',TO_DATE('16-MAY-2022 13:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(132,594,746,'16-MAY-2022',TO_DATE('16-MAY-2022 0:33','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(132,594,743,'16-MAY-2022',TO_DATE('16-MAY-2022 10:36','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(132,594,743,'16-MAY-2022',TO_DATE('16-MAY-2022 9:14','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(138,592,743,'16-MAY-2022',TO_DATE('16-MAY-2022 17:38','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(138,777,745,'16-MAY-2022',TO_DATE('16-MAY-2022 15:59','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(138,769,743,'16-MAY-2022',TO_DATE('16-MAY-2022 22:22','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(139,592,741,'16-MAY-2022',TO_DATE('16-MAY-2022 4:44','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(139,777,742,'16-MAY-2022',TO_DATE('16-MAY-2022 16:40','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(164,801,747,'16-MAY-2022',TO_DATE('16-MAY-2022 16:11','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(176,593,741,'16-MAY-2022',TO_DATE('16-MAY-2022 16:24','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(184,593,743,'16-MAY-2022',TO_DATE('16-MAY-2022 18:43','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(184,775,746,'16-MAY-2022',TO_DATE('16-MAY-2022 13:49','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(184,594,743,'16-MAY-2022',TO_DATE('16-MAY-2022 16:40','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(209,777,743,'16-MAY-2022',TO_DATE('16-MAY-2022 19:15','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(243,775,742,'16-MAY-2022',TO_DATE('16-MAY-2022 5:9','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(243,801,747,'16-MAY-2022',TO_DATE('16-MAY-2022 3:35','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(243,594,741,'16-MAY-2022',TO_DATE('16-MAY-2022 3:48','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(251,593,746,'16-MAY-2022',TO_DATE('16-MAY-2022 20:3','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(251,801,745,'16-MAY-2022',TO_DATE('16-MAY-2022 5:48','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(258,592,740,'16-MAY-2022',TO_DATE('16-MAY-2022 10:43','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(258,769,747,'16-MAY-2022',TO_DATE('16-MAY-2022 7:10','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(283,777,745,'16-MAY-2022',TO_DATE('16-MAY-2022 6:15','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(300,593,742,'16-MAY-2022',TO_DATE('16-MAY-2022 7:18','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(300,594,747,'16-MAY-2022',TO_DATE('16-MAY-2022 12:0','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(300,594,742,'16-MAY-2022',TO_DATE('16-MAY-2022 13:57','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(303,777,741,'16-MAY-2022',TO_DATE('16-MAY-2022 1:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(303,801,742,'16-MAY-2022',TO_DATE('16-MAY-2022 7:54','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(357,594,747,'16-MAY-2022',TO_DATE('16-MAY-2022 6:27','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(357,801,747,'16-MAY-2022',TO_DATE('16-MAY-2022 23:21','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(357,594,747,'16-MAY-2022',TO_DATE('16-MAY-2022 9:42','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(369,769,747,'16-MAY-2022',TO_DATE('16-MAY-2022 2:2','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(369,592,747,'16-MAY-2022',TO_DATE('16-MAY-2022 4:37','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(369,777,747,'16-MAY-2022',TO_DATE('16-MAY-2022 14:37','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(370,775,744,'16-MAY-2022',TO_DATE('16-MAY-2022 14:39','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(371,592,742,'16-MAY-2022',TO_DATE('16-MAY-2022 11:47','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(377,777,747,'16-MAY-2022',TO_DATE('16-MAY-2022 19:45','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(377,593,747,'16-MAY-2022',TO_DATE('16-MAY-2022 4:30','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(379,593,743,'16-MAY-2022',TO_DATE('16-MAY-2022 17:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(379,769,743,'16-MAY-2022',TO_DATE('16-MAY-2022 4:8','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(388,769,744,'16-MAY-2022',TO_DATE('16-MAY-2022 22:15','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(392,592,745,'16-MAY-2022',TO_DATE('16-MAY-2022 10:15','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(392,594,745,'16-MAY-2022',TO_DATE('16-MAY-2022 12:2','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(439,801,742,'16-MAY-2022',TO_DATE('16-MAY-2022 1:58','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(439,593,747,'16-MAY-2022',TO_DATE('16-MAY-2022 3:36','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(439,593,747,'16-MAY-2022',TO_DATE('16-MAY-2022 2:34','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(112,611,751,'16-MAY-2022',TO_DATE('16-MAY-2022 13:28','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(112,612,752,'16-MAY-2022',TO_DATE('16-MAY-2022 11:52','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(118,595,751,'16-MAY-2022',TO_DATE('16-MAY-2022 8:34','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(118,611,757,'16-MAY-2022',TO_DATE('16-MAY-2022 4:10','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(118,611,751,'16-MAY-2022',TO_DATE('16-MAY-2022 3:34','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(140,612,754,'16-MAY-2022',TO_DATE('16-MAY-2022 9:38','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(140,610,754,'16-MAY-2022',TO_DATE('16-MAY-2022 9:11','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(140,595,754,'16-MAY-2022',TO_DATE('16-MAY-2022 15:53','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(154,610,751,'16-MAY-2022',TO_DATE('16-MAY-2022 13:57','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(154,611,758,'16-MAY-2022',TO_DATE('16-MAY-2022 16:16','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(190,612,754,'16-MAY-2022',TO_DATE('16-MAY-2022 6:40','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(190,612,754,'16-MAY-2022',TO_DATE('16-MAY-2022 23:36','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(190,611,754,'16-MAY-2022',TO_DATE('16-MAY-2022 11:2','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(249,595,759,'16-MAY-2022',TO_DATE('16-MAY-2022 23:4','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(254,611,757,'16-MAY-2022',TO_DATE('16-MAY-2022 1:51','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(254,611,757,'16-MAY-2022',TO_DATE('16-MAY-2022 7:57','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(254,610,757,'16-MAY-2022',TO_DATE('16-MAY-2022 16:29','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(272,611,754,'16-MAY-2022',TO_DATE('16-MAY-2022 8:13','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(296,610,753,'16-MAY-2022',TO_DATE('16-MAY-2022 17:20','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(296,610,753,'16-MAY-2022',TO_DATE('16-MAY-2022 3:36','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(296,611,753,'16-MAY-2022',TO_DATE('16-MAY-2022 21:16','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(310,611,755,'16-MAY-2022',TO_DATE('16-MAY-2022 7:32','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(310,612,756,'16-MAY-2022',TO_DATE('16-MAY-2022 3:41','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(312,596,757,'16-MAY-2022',TO_DATE('16-MAY-2022 10:21','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(318,610,757,'16-MAY-2022',TO_DATE('16-MAY-2022 19:43','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(334,610,756,'16-MAY-2022',TO_DATE('16-MAY-2022 10:45','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(334,610,753,'16-MAY-2022',TO_DATE('16-MAY-2022 13:17','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(334,611,755,'16-MAY-2022',TO_DATE('16-MAY-2022 22:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(367,610,753,'16-MAY-2022',TO_DATE('16-MAY-2022 17:46','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(367,610,755,'16-MAY-2022',TO_DATE('16-MAY-2022 14:36','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(376,611,757,'16-MAY-2022',TO_DATE('16-MAY-2022 13:37','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(397,612,757,'16-MAY-2022',TO_DATE('16-MAY-2022 21:20','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(397,610,757,'16-MAY-2022',TO_DATE('16-MAY-2022 6:59','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(397,612,757,'16-MAY-2022',TO_DATE('16-MAY-2022 2:50','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(411,610,757,'16-MAY-2022',TO_DATE('16-MAY-2022 1:28','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(411,612,757,'16-MAY-2022',TO_DATE('16-MAY-2022 13:50','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(420,611,754,'16-MAY-2022',TO_DATE('16-MAY-2022 16:27','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(432,610,757,'16-MAY-2022',TO_DATE('16-MAY-2022 23:1','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(108,627,762,'16-MAY-2022',TO_DATE('16-MAY-2022 23:34','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(108,626,762,'16-MAY-2022',TO_DATE('16-MAY-2022 21:15','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(108,629,762,'16-MAY-2022',TO_DATE('16-MAY-2022 6:22','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(113,630,765,'16-MAY-2022',TO_DATE('16-MAY-2022 20:59','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(145,626,765,'16-MAY-2022',TO_DATE('16-MAY-2022 20:17','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(145,629,760,'16-MAY-2022',TO_DATE('16-MAY-2022 16:45','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(159,629,767,'16-MAY-2022',TO_DATE('16-MAY-2022 9:49','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(159,630,761,'16-MAY-2022',TO_DATE('16-MAY-2022 22:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(159,630,761,'16-MAY-2022',TO_DATE('16-MAY-2022 11:20','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(187,629,762,'16-MAY-2022',TO_DATE('16-MAY-2022 8:27','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(187,630,767,'16-MAY-2022',TO_DATE('16-MAY-2022 9:17','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(204,627,764,'16-MAY-2022',TO_DATE('16-MAY-2022 14:11','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(204,627,764,'16-MAY-2022',TO_DATE('16-MAY-2022 13:10','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(204,630,764,'16-MAY-2022',TO_DATE('16-MAY-2022 18:9','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(207,630,767,'16-MAY-2022',TO_DATE('16-MAY-2022 16:59','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(215,631,762,'16-MAY-2022',TO_DATE('16-MAY-2022 13:27','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(215,629,762,'16-MAY-2022',TO_DATE('16-MAY-2022 8:12','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(217,629,768,'16-MAY-2022',TO_DATE('16-MAY-2022 8:26','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(217,631,763,'16-MAY-2022',TO_DATE('16-MAY-2022 10:47','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(217,631,760,'16-MAY-2022',TO_DATE('16-MAY-2022 2:52','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(221,629,761,'16-MAY-2022',TO_DATE('16-MAY-2022 1:8','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(221,631,767,'16-MAY-2022',TO_DATE('16-MAY-2022 21:7','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(221,626,761,'16-MAY-2022',TO_DATE('16-MAY-2022 22:45','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(228,630,764,'16-MAY-2022',TO_DATE('16-MAY-2022 18:40','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(228,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 15:33','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(228,629,764,'16-MAY-2022',TO_DATE('16-MAY-2022 8:18','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(231,626,766,'16-MAY-2022',TO_DATE('16-MAY-2022 2:57','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(231,629,760,'16-MAY-2022',TO_DATE('16-MAY-2022 19:47','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(248,629,766,'16-MAY-2022',TO_DATE('16-MAY-2022 9:10','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(248,629,765,'16-MAY-2022',TO_DATE('16-MAY-2022 23:26','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(248,629,768,'16-MAY-2022',TO_DATE('16-MAY-2022 16:27','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(259,631,761,'16-MAY-2022',TO_DATE('16-MAY-2022 21:17','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(269,626,764,'16-MAY-2022',TO_DATE('16-MAY-2022 18:13','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(269,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 17:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(295,631,761,'16-MAY-2022',TO_DATE('16-MAY-2022 0:36','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(295,627,767,'16-MAY-2022',TO_DATE('16-MAY-2022 22:37','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(321,627,767,'16-MAY-2022',TO_DATE('16-MAY-2022 3:22','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(328,630,764,'16-MAY-2022',TO_DATE('16-MAY-2022 11:51','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(328,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 7:15','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(328,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 3:25','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(373,629,767,'16-MAY-2022',TO_DATE('16-MAY-2022 14:11','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(373,627,762,'16-MAY-2022',TO_DATE('16-MAY-2022 10:54','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(373,630,762,'16-MAY-2022',TO_DATE('16-MAY-2022 4:19','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(383,626,764,'16-MAY-2022',TO_DATE('16-MAY-2022 4:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(393,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 1:6','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(393,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 23:49','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(393,631,764,'16-MAY-2022',TO_DATE('16-MAY-2022 15:23','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(410,626,762,'16-MAY-2022',TO_DATE('16-MAY-2022 23:20','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(158,648,776,'16-MAY-2022',TO_DATE('16-MAY-2022 8:39','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(158,647,773,'16-MAY-2022',TO_DATE('16-MAY-2022 4:14','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(158,649,776,'16-MAY-2022',TO_DATE('16-MAY-2022 10:6','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(167,649,772,'16-MAY-2022',TO_DATE('16-MAY-2022 7:52','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(172,637,774,'16-MAY-2022',TO_DATE('16-MAY-2022 13:12','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(172,649,774,'16-MAY-2022',TO_DATE('16-MAY-2022 20:57','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(178,637,773,'16-MAY-2022',TO_DATE('16-MAY-2022 15:11','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(178,649,778,'16-MAY-2022',TO_DATE('16-MAY-2022 14:3','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(195,647,777,'16-MAY-2022',TO_DATE('16-MAY-2022 1:13','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(223,648,774,'16-MAY-2022',TO_DATE('16-MAY-2022 18:53','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(237,649,776,'16-MAY-2022',TO_DATE('16-MAY-2022 16:22','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(237,649,777,'16-MAY-2022',TO_DATE('16-MAY-2022 10:6','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(237,649,770,'16-MAY-2022',TO_DATE('16-MAY-2022 8:9','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(266,648,777,'16-MAY-2022',TO_DATE('16-MAY-2022 4:52','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(266,648,772,'16-MAY-2022',TO_DATE('16-MAY-2022 10:56','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(274,647,772,'16-MAY-2022',TO_DATE('16-MAY-2022 8:4','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(276,649,776,'16-MAY-2022',TO_DATE('16-MAY-2022 23:52','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(322,647,778,'16-MAY-2022',TO_DATE('16-MAY-2022 10:29','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(322,647,775,'16-MAY-2022',TO_DATE('16-MAY-2022 3:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(322,649,772,'16-MAY-2022',TO_DATE('16-MAY-2022 20:23','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(325,648,773,'16-MAY-2022',TO_DATE('16-MAY-2022 21:30','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(333,648,771,'16-MAY-2022',TO_DATE('16-MAY-2022 19:39','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(333,648,777,'16-MAY-2022',TO_DATE('16-MAY-2022 8:33','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(333,648,771,'16-MAY-2022',TO_DATE('16-MAY-2022 23:11','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(335,649,774,'16-MAY-2022',TO_DATE('16-MAY-2022 14:23','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(335,647,774,'16-MAY-2022',TO_DATE('16-MAY-2022 9:49','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(350,647,776,'16-MAY-2022',TO_DATE('16-MAY-2022 7:35','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(350,649,773,'16-MAY-2022',TO_DATE('16-MAY-2022 20:40','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(350,649,776,'16-MAY-2022',TO_DATE('16-MAY-2022 2:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(359,649,772,'16-MAY-2022',TO_DATE('16-MAY-2022 13:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(359,648,771,'16-MAY-2022',TO_DATE('16-MAY-2022 6:37','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(361,649,771,'16-MAY-2022',TO_DATE('16-MAY-2022 16:9','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(361,647,771,'16-MAY-2022',TO_DATE('16-MAY-2022 23:0','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(361,649,771,'16-MAY-2022',TO_DATE('16-MAY-2022 3:31','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(364,648,777,'16-MAY-2022',TO_DATE('16-MAY-2022 5:54','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(364,648,777,'16-MAY-2022',TO_DATE('16-MAY-2022 5:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(364,647,771,'16-MAY-2022',TO_DATE('16-MAY-2022 15:17','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(381,649,771,'16-MAY-2022',TO_DATE('16-MAY-2022 22:8','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(381,647,772,'16-MAY-2022',TO_DATE('16-MAY-2022 21:6','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(385,648,772,'16-MAY-2022',TO_DATE('16-MAY-2022 8:47','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(385,637,777,'16-MAY-2022',TO_DATE('16-MAY-2022 12:1','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(385,648,777,'16-MAY-2022',TO_DATE('16-MAY-2022 11:59','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(437,649,772,'16-MAY-2022',TO_DATE('16-MAY-2022 1:24','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(437,647,771,'16-MAY-2022',TO_DATE('16-MAY-2022 16:46','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(437,648,777,'16-MAY-2022',TO_DATE('16-MAY-2022 2:16','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(117,666,784,'16-MAY-2022',TO_DATE('16-MAY-2022 21:20','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(129,667,786,'16-MAY-2022',TO_DATE('16-MAY-2022 18:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(143,782,783,'16-MAY-2022',TO_DATE('16-MAY-2022 23:53','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(143,666,785,'16-MAY-2022',TO_DATE('16-MAY-2022 0:40','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(143,782,786,'16-MAY-2022',TO_DATE('16-MAY-2022 17:42','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(156,665,787,'16-MAY-2022',TO_DATE('16-MAY-2022 3:55','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(156,654,787,'16-MAY-2022',TO_DATE('16-MAY-2022 16:24','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(156,654,787,'16-MAY-2022',TO_DATE('16-MAY-2022 5:5','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(160,800,787,'16-MAY-2022',TO_DATE('16-MAY-2022 17:34','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(160,800,781,'16-MAY-2022',TO_DATE('16-MAY-2022 2:46','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(160,800,787,'16-MAY-2022',TO_DATE('16-MAY-2022 0:45','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(161,782,781,'16-MAY-2022',TO_DATE('16-MAY-2022 11:4','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(161,665,787,'16-MAY-2022',TO_DATE('16-MAY-2022 6:7','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(161,667,787,'16-MAY-2022',TO_DATE('16-MAY-2022 2:22','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(186,800,783,'16-MAY-2022',TO_DATE('16-MAY-2022 15:2','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(186,665,786,'16-MAY-2022',TO_DATE('16-MAY-2022 3:37','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(189,666,781,'16-MAY-2022',TO_DATE('16-MAY-2022 5:23','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(189,782,782,'16-MAY-2022',TO_DATE('16-MAY-2022 13:53','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(214,800,784,'16-MAY-2022',TO_DATE('16-MAY-2022 18:14','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(214,665,784,'16-MAY-2022',TO_DATE('16-MAY-2022 20:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(229,800,785,'16-MAY-2022',TO_DATE('16-MAY-2022 0:46','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(229,667,786,'16-MAY-2022',TO_DATE('16-MAY-2022 10:10','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(229,665,780,'16-MAY-2022',TO_DATE('16-MAY-2022 17:10','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(230,782,784,'16-MAY-2022',TO_DATE('16-MAY-2022 11:9','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(230,666,784,'16-MAY-2022',TO_DATE('16-MAY-2022 12:31','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(238,666,785,'16-MAY-2022',TO_DATE('16-MAY-2022 10:4','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(238,800,785,'16-MAY-2022',TO_DATE('16-MAY-2022 7:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(260,666,781,'16-MAY-2022',TO_DATE('16-MAY-2022 17:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(260,665,782,'16-MAY-2022',TO_DATE('16-MAY-2022 20:16','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(267,665,784,'16-MAY-2022',TO_DATE('16-MAY-2022 15:0','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(267,667,784,'16-MAY-2022',TO_DATE('16-MAY-2022 16:44','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(267,665,784,'16-MAY-2022',TO_DATE('16-MAY-2022 21:47','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(271,654,784,'16-MAY-2022',TO_DATE('16-MAY-2022 5:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(271,667,784,'16-MAY-2022',TO_DATE('16-MAY-2022 13:3','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(273,667,782,'16-MAY-2022',TO_DATE('16-MAY-2022 5:15','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(273,667,780,'16-MAY-2022',TO_DATE('16-MAY-2022 8:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(273,665,785,'16-MAY-2022',TO_DATE('16-MAY-2022 20:3','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(281,666,782,'16-MAY-2022',TO_DATE('16-MAY-2022 4:46','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(292,665,785,'16-MAY-2022',TO_DATE('16-MAY-2022 16:34','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(292,665,780,'16-MAY-2022',TO_DATE('16-MAY-2022 9:54','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(299,666,787,'16-MAY-2022',TO_DATE('16-MAY-2022 12:52','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(299,782,781,'16-MAY-2022',TO_DATE('16-MAY-2022 7:4','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(302,666,786,'16-MAY-2022',TO_DATE('16-MAY-2022 0:5','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(302,800,787,'16-MAY-2022',TO_DATE('16-MAY-2022 22:9','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(302,666,783,'16-MAY-2022',TO_DATE('16-MAY-2022 17:33','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(305,666,781,'16-MAY-2022',TO_DATE('16-MAY-2022 15:54','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(309,800,784,'16-MAY-2022',TO_DATE('16-MAY-2022 2:40','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(311,782,787,'16-MAY-2022',TO_DATE('16-MAY-2022 9:34','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(311,782,787,'16-MAY-2022',TO_DATE('16-MAY-2022 14:24','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(311,667,787,'16-MAY-2022',TO_DATE('16-MAY-2022 18:3','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(316,665,787,'16-MAY-2022',TO_DATE('16-MAY-2022 5:11','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(324,654,783,'16-MAY-2022',TO_DATE('16-MAY-2022 4:5','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(329,667,781,'16-MAY-2022',TO_DATE('16-MAY-2022 12:44','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(349,800,784,'16-MAY-2022',TO_DATE('16-MAY-2022 6:43','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(349,782,784,'16-MAY-2022',TO_DATE('16-MAY-2022 13:45','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(354,782,783,'16-MAY-2022',TO_DATE('16-MAY-2022 15:51','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(354,666,785,'16-MAY-2022',TO_DATE('16-MAY-2022 12:35','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(356,800,788,'16-MAY-2022',TO_DATE('16-MAY-2022 1:56','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(356,782,786,'16-MAY-2022',TO_DATE('16-MAY-2022 20:16','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(356,667,783,'16-MAY-2022',TO_DATE('16-MAY-2022 4:56','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(358,667,782,'16-MAY-2022',TO_DATE('16-MAY-2022 14:12','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(358,782,787,'16-MAY-2022',TO_DATE('16-MAY-2022 9:42','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(375,800,787,'16-MAY-2022',TO_DATE('16-MAY-2022 8:53','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(375,782,787,'16-MAY-2022',TO_DATE('16-MAY-2022 7:13','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(406,800,786,'16-MAY-2022',TO_DATE('16-MAY-2022 0:1','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(406,667,788,'16-MAY-2022',TO_DATE('16-MAY-2022 16:31','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(406,667,783,'16-MAY-2022',TO_DATE('16-MAY-2022 23:23','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(423,665,782,'16-MAY-2022',TO_DATE('16-MAY-2022 8:10','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(423,667,787,'16-MAY-2022',TO_DATE('16-MAY-2022 2:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(423,665,788,'16-MAY-2022',TO_DATE('16-MAY-2022 5:24','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(426,654,781,'16-MAY-2022',TO_DATE('16-MAY-2022 1:24','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(426,667,782,'16-MAY-2022',TO_DATE('16-MAY-2022 17:20','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(109,679,795,'16-MAY-2022',TO_DATE('16-MAY-2022 18:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(109,685,793,'16-MAY-2022',TO_DATE('16-MAY-2022 22:51','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(119,671,790,'16-MAY-2022',TO_DATE('16-MAY-2022 18:5','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(119,685,795,'16-MAY-2022',TO_DATE('16-MAY-2022 11:40','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(119,685,793,'16-MAY-2022',TO_DATE('16-MAY-2022 2:7','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(122,671,794,'16-MAY-2022',TO_DATE('16-MAY-2022 19:32','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(122,668,794,'16-MAY-2022',TO_DATE('16-MAY-2022 13:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(127,671,797,'16-MAY-2022',TO_DATE('16-MAY-2022 2:30','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(127,802,791,'16-MAY-2022',TO_DATE('16-MAY-2022 1:57','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(127,684,792,'16-MAY-2022',TO_DATE('16-MAY-2022 10:19','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(136,685,793,'16-MAY-2022',TO_DATE('16-MAY-2022 5:57','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(136,671,795,'16-MAY-2022',TO_DATE('16-MAY-2022 14:56','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(136,684,793,'16-MAY-2022',TO_DATE('16-MAY-2022 11:34','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(196,671,793,'16-MAY-2022',TO_DATE('16-MAY-2022 19:44','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(196,671,793,'16-MAY-2022',TO_DATE('16-MAY-2022 10:25','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(196,685,795,'16-MAY-2022',TO_DATE('16-MAY-2022 21:21','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(206,679,794,'16-MAY-2022',TO_DATE('16-MAY-2022 22:45','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(241,802,791,'16-MAY-2022',TO_DATE('16-MAY-2022 14:37','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(246,685,795,'16-MAY-2022',TO_DATE('16-MAY-2022 3:57','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(246,685,795,'16-MAY-2022',TO_DATE('16-MAY-2022 7:31','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(268,802,791,'16-MAY-2022',TO_DATE('16-MAY-2022 2:24','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(289,668,794,'16-MAY-2022',TO_DATE('16-MAY-2022 6:21','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(289,668,794,'16-MAY-2022',TO_DATE('16-MAY-2022 20:8','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(289,686,794,'16-MAY-2022',TO_DATE('16-MAY-2022 16:10','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(314,668,797,'16-MAY-2022',TO_DATE('16-MAY-2022 9:47','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(314,668,797,'16-MAY-2022',TO_DATE('16-MAY-2022 0:54','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(315,685,791,'16-MAY-2022',TO_DATE('16-MAY-2022 21:24','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(315,686,790,'16-MAY-2022',TO_DATE('16-MAY-2022 2:7','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(315,802,797,'16-MAY-2022',TO_DATE('16-MAY-2022 12:11','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(341,679,796,'16-MAY-2022',TO_DATE('16-MAY-2022 11:27','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(341,685,791,'16-MAY-2022',TO_DATE('16-MAY-2022 14:3','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(341,802,790,'16-MAY-2022',TO_DATE('16-MAY-2022 20:58','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(360,679,794,'16-MAY-2022',TO_DATE('16-MAY-2022 19:34','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(360,684,794,'16-MAY-2022',TO_DATE('16-MAY-2022 7:57','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(365,671,794,'16-MAY-2022',TO_DATE('16-MAY-2022 21:5','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(365,671,794,'16-MAY-2022',TO_DATE('16-MAY-2022 4:38','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(365,685,794,'16-MAY-2022',TO_DATE('16-MAY-2022 5:12','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(382,686,794,'16-MAY-2022',TO_DATE('16-MAY-2022 14:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(382,685,794,'16-MAY-2022',TO_DATE('16-MAY-2022 19:19','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(382,802,794,'16-MAY-2022',TO_DATE('16-MAY-2022 11:19','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(390,685,792,'16-MAY-2022',TO_DATE('16-MAY-2022 21:46','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(390,684,792,'16-MAY-2022',TO_DATE('16-MAY-2022 5:37','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(390,679,792,'16-MAY-2022',TO_DATE('16-MAY-2022 17:27','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(398,685,797,'16-MAY-2022',TO_DATE('16-MAY-2022 15:4','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(398,686,797,'16-MAY-2022',TO_DATE('16-MAY-2022 9:5','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(418,668,791,'16-MAY-2022',TO_DATE('16-MAY-2022 21:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(418,802,797,'16-MAY-2022',TO_DATE('16-MAY-2022 4:33','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(434,685,791,'16-MAY-2022',TO_DATE('16-MAY-2022 21:48','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(434,679,797,'16-MAY-2022',TO_DATE('16-MAY-2022 20:27','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(434,684,791,'16-MAY-2022',TO_DATE('16-MAY-2022 4:45','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(105,705,805,'16-MAY-2022',TO_DATE('16-MAY-2022 17:25','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(105,707,806,'16-MAY-2022',TO_DATE('16-MAY-2022 2:38','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(105,706,808,'16-MAY-2022',TO_DATE('16-MAY-2022 18:30','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(126,705,801,'16-MAY-2022',TO_DATE('16-MAY-2022 12:44','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(131,706,807,'16-MAY-2022',TO_DATE('16-MAY-2022 23:4','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(131,696,807,'16-MAY-2022',TO_DATE('16-MAY-2022 17:34','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(131,705,807,'16-MAY-2022',TO_DATE('16-MAY-2022 18:48','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(135,705,805,'16-MAY-2022',TO_DATE('16-MAY-2022 12:37','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(135,783,805,'16-MAY-2022',TO_DATE('16-MAY-2022 11:36','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(135,707,803,'16-MAY-2022',TO_DATE('16-MAY-2022 7:36','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(147,706,800,'16-MAY-2022',TO_DATE('16-MAY-2022 6:17','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(147,707,806,'16-MAY-2022',TO_DATE('16-MAY-2022 6:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(152,707,803,'16-MAY-2022',TO_DATE('16-MAY-2022 13:6','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(152,706,808,'16-MAY-2022',TO_DATE('16-MAY-2022 19:39','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(183,783,806,'16-MAY-2022',TO_DATE('16-MAY-2022 22:55','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(197,707,807,'16-MAY-2022',TO_DATE('16-MAY-2022 18:31','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(197,783,803,'16-MAY-2022',TO_DATE('16-MAY-2022 1:27','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(205,706,801,'16-MAY-2022',TO_DATE('16-MAY-2022 19:15','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(205,692,801,'16-MAY-2022',TO_DATE('16-MAY-2022 22:36','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(205,690,807,'16-MAY-2022',TO_DATE('16-MAY-2022 22:48','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(213,707,800,'16-MAY-2022',TO_DATE('16-MAY-2022 7:21','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(213,696,801,'16-MAY-2022',TO_DATE('16-MAY-2022 22:36','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(232,706,807,'16-MAY-2022',TO_DATE('16-MAY-2022 6:15','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(232,707,801,'16-MAY-2022',TO_DATE('16-MAY-2022 21:44','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(234,783,802,'16-MAY-2022',TO_DATE('16-MAY-2022 13:35','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(234,696,805,'16-MAY-2022',TO_DATE('16-MAY-2022 12:24','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(234,783,805,'16-MAY-2022',TO_DATE('16-MAY-2022 16:5','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(236,696,802,'16-MAY-2022',TO_DATE('16-MAY-2022 17:45','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(236,707,807,'16-MAY-2022',TO_DATE('16-MAY-2022 2:58','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(263,783,804,'16-MAY-2022',TO_DATE('16-MAY-2022 12:0','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(279,690,800,'16-MAY-2022',TO_DATE('16-MAY-2022 4:54','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(290,690,804,'16-MAY-2022',TO_DATE('16-MAY-2022 4:25','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(293,707,801,'16-MAY-2022',TO_DATE('16-MAY-2022 15:7','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(294,706,801,'16-MAY-2022',TO_DATE('16-MAY-2022 0:59','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(294,706,801,'16-MAY-2022',TO_DATE('16-MAY-2022 6:55','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(297,705,806,'16-MAY-2022',TO_DATE('16-MAY-2022 22:2','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(304,707,803,'16-MAY-2022',TO_DATE('16-MAY-2022 20:26','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(304,706,805,'16-MAY-2022',TO_DATE('16-MAY-2022 11:37','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(306,692,807,'16-MAY-2022',TO_DATE('16-MAY-2022 18:20','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(306,707,802,'16-MAY-2022',TO_DATE('16-MAY-2022 21:40','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(308,696,807,'16-MAY-2022',TO_DATE('16-MAY-2022 13:6','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(308,692,807,'16-MAY-2022',TO_DATE('16-MAY-2022 4:47','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(327,706,804,'16-MAY-2022',TO_DATE('16-MAY-2022 14:30','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(343,705,802,'16-MAY-2022',TO_DATE('16-MAY-2022 4:7','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(343,707,807,'16-MAY-2022',TO_DATE('16-MAY-2022 16:12','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(362,707,801,'16-MAY-2022',TO_DATE('16-MAY-2022 1:41','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(362,692,802,'16-MAY-2022',TO_DATE('16-MAY-2022 4:52','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(362,705,802,'16-MAY-2022',TO_DATE('16-MAY-2022 4:29','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(384,705,807,'16-MAY-2022',TO_DATE('16-MAY-2022 21:53','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(384,706,807,'16-MAY-2022',TO_DATE('16-MAY-2022 10:49','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(384,783,801,'16-MAY-2022',TO_DATE('16-MAY-2022 23:3','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(396,690,803,'16-MAY-2022',TO_DATE('16-MAY-2022 13:1','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(417,707,802,'16-MAY-2022',TO_DATE('16-MAY-2022 13:45','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(417,690,808,'16-MAY-2022',TO_DATE('16-MAY-2022 10:34','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(417,706,802,'16-MAY-2022',TO_DATE('16-MAY-2022 8:40','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(422,692,802,'16-MAY-2022',TO_DATE('16-MAY-2022 4:7','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(422,706,803,'16-MAY-2022',TO_DATE('16-MAY-2022 4:53','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(422,707,806,'16-MAY-2022',TO_DATE('16-MAY-2022 7:14','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(103,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 20:10','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(103,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 10:36','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(130,797,814,'16-MAY-2022',TO_DATE('16-MAY-2022 17:26','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(130,724,814,'16-MAY-2022',TO_DATE('16-MAY-2022 0:1','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(130,724,814,'16-MAY-2022',TO_DATE('16-MAY-2022 8:58','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(133,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 0:37','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(151,725,816,'16-MAY-2022',TO_DATE('16-MAY-2022 1:53','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(151,725,811,'16-MAY-2022',TO_DATE('16-MAY-2022 7:4','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(151,724,810,'16-MAY-2022',TO_DATE('16-MAY-2022 8:37','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(162,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 13:22','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(163,725,814,'16-MAY-2022',TO_DATE('16-MAY-2022 19:36','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(173,796,818,'16-MAY-2022',TO_DATE('16-MAY-2022 0:48','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(182,726,817,'16-MAY-2022',TO_DATE('16-MAY-2022 0:8','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(185,725,812,'16-MAY-2022',TO_DATE('16-MAY-2022 1:16','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(185,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 10:33','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(185,726,812,'16-MAY-2022',TO_DATE('16-MAY-2022 17:57','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(194,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 15:56','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(194,726,817,'16-MAY-2022',TO_DATE('16-MAY-2022 15:54','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(194,796,817,'16-MAY-2022',TO_DATE('16-MAY-2022 12:31','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(199,725,812,'16-MAY-2022',TO_DATE('16-MAY-2022 5:4','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(199,725,811,'16-MAY-2022',TO_DATE('16-MAY-2022 0:51','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(199,726,812,'16-MAY-2022',TO_DATE('16-MAY-2022 8:4','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(208,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 9:41','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(208,726,811,'16-MAY-2022',TO_DATE('16-MAY-2022 3:19','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(211,726,811,'16-MAY-2022',TO_DATE('16-MAY-2022 9:49','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(211,725,816,'16-MAY-2022',TO_DATE('16-MAY-2022 2:26','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(226,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 14:27','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(226,796,811,'16-MAY-2022',TO_DATE('16-MAY-2022 10:16','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(226,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 15:39','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(282,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 10:2','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(282,725,811,'16-MAY-2022',TO_DATE('16-MAY-2022 5:38','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(282,726,811,'16-MAY-2022',TO_DATE('16-MAY-2022 18:50','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(287,726,814,'16-MAY-2022',TO_DATE('16-MAY-2022 16:48','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(287,726,814,'16-MAY-2022',TO_DATE('16-MAY-2022 14:16','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(287,724,814,'16-MAY-2022',TO_DATE('16-MAY-2022 6:45','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(301,796,812,'16-MAY-2022',TO_DATE('16-MAY-2022 22:36','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(301,796,812,'16-MAY-2022',TO_DATE('16-MAY-2022 13:38','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(301,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 22:1','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(336,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 10:22','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(336,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 19:50','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(336,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 2:55','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(339,726,818,'16-MAY-2022',TO_DATE('16-MAY-2022 7:23','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(339,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 6:15','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(344,724,814,'16-MAY-2022',TO_DATE('16-MAY-2022 12:34','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(344,725,814,'16-MAY-2022',TO_DATE('16-MAY-2022 10:54','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(348,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 2:47','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(348,725,812,'16-MAY-2022',TO_DATE('16-MAY-2022 20:56','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(348,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 19:32','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(351,725,817,'16-MAY-2022',TO_DATE('16-MAY-2022 6:40','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(352,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 15:55','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(352,796,817,'16-MAY-2022',TO_DATE('16-MAY-2022 6:59','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(352,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 23:31','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(353,726,810,'16-MAY-2022',TO_DATE('16-MAY-2022 4:19','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(353,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 19:23','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(363,724,812,'16-MAY-2022',TO_DATE('16-MAY-2022 15:41','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(363,725,811,'16-MAY-2022',TO_DATE('16-MAY-2022 19:54','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(374,725,816,'16-MAY-2022',TO_DATE('16-MAY-2022 15:31','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(374,724,815,'16-MAY-2022',TO_DATE('16-MAY-2022 2:47','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(380,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 9:52','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(386,726,815,'16-MAY-2022',TO_DATE('16-MAY-2022 5:51','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(386,726,813,'16-MAY-2022',TO_DATE('16-MAY-2022 3:37','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(386,797,813,'16-MAY-2022',TO_DATE('16-MAY-2022 19:47','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(394,726,814,'16-MAY-2022',TO_DATE('16-MAY-2022 17:42','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(425,725,817,'16-MAY-2022',TO_DATE('16-MAY-2022 4:32','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(430,797,814,'16-MAY-2022',TO_DATE('16-MAY-2022 23:23','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(430,726,814,'16-MAY-2022',TO_DATE('16-MAY-2022 21:24','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(430,726,814,'16-MAY-2022',TO_DATE('16-MAY-2022 12:24','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(435,797,817,'16-MAY-2022',TO_DATE('16-MAY-2022 12:7','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(435,724,817,'16-MAY-2022',TO_DATE('16-MAY-2022 3:42','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(107,798,826,'16-MAY-2022',TO_DATE('16-MAY-2022 0:46','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(107,745,823,'16-MAY-2022',TO_DATE('16-MAY-2022 9:50','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(107,781,826,'16-MAY-2022',TO_DATE('16-MAY-2022 11:53','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(116,736,825,'16-MAY-2022',TO_DATE('16-MAY-2022 6:31','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(125,744,827,'16-MAY-2022',TO_DATE('16-MAY-2022 8:11','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(125,745,821,'16-MAY-2022',TO_DATE('16-MAY-2022 4:14','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(128,744,820,'16-MAY-2022',TO_DATE('16-MAY-2022 1:26','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(128,743,828,'16-MAY-2022',TO_DATE('16-MAY-2022 16:36','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(149,781,821,'16-MAY-2022',TO_DATE('16-MAY-2022 0:3','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(149,745,821,'16-MAY-2022',TO_DATE('16-MAY-2022 18:9','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(149,781,822,'16-MAY-2022',TO_DATE('16-MAY-2022 14:53','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(157,745,822,'16-MAY-2022',TO_DATE('16-MAY-2022 20:4','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(157,781,821,'16-MAY-2022',TO_DATE('16-MAY-2022 0:48','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(157,743,827,'16-MAY-2022',TO_DATE('16-MAY-2022 21:17','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(170,798,825,'16-MAY-2022',TO_DATE('16-MAY-2022 23:5','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(170,743,823,'16-MAY-2022',TO_DATE('16-MAY-2022 4:49','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(179,744,826,'16-MAY-2022',TO_DATE('16-MAY-2022 16:34','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(179,743,827,'16-MAY-2022',TO_DATE('16-MAY-2022 11:25','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(180,781,822,'16-MAY-2022',TO_DATE('16-MAY-2022 8:8','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(180,790,822,'16-MAY-2022',TO_DATE('16-MAY-2022 1:5','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(180,743,821,'16-MAY-2022',TO_DATE('16-MAY-2022 3:47','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(198,743,827,'16-MAY-2022',TO_DATE('16-MAY-2022 5:6','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(198,743,820,'16-MAY-2022',TO_DATE('16-MAY-2022 3:17','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(225,790,825,'16-MAY-2022',TO_DATE('16-MAY-2022 4:56','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(245,781,827,'16-MAY-2022',TO_DATE('16-MAY-2022 16:59','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(250,745,820,'16-MAY-2022',TO_DATE('16-MAY-2022 8:50','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(252,745,828,'16-MAY-2022',TO_DATE('16-MAY-2022 18:59','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(252,743,826,'16-MAY-2022',TO_DATE('16-MAY-2022 12:47','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(253,744,821,'16-MAY-2022',TO_DATE('16-MAY-2022 20:43','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(253,736,822,'16-MAY-2022',TO_DATE('16-MAY-2022 14:15','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(255,744,822,'16-MAY-2022',TO_DATE('16-MAY-2022 12:38','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(270,736,825,'16-MAY-2022',TO_DATE('16-MAY-2022 17:43','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(270,743,820,'16-MAY-2022',TO_DATE('16-MAY-2022 10:40','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(320,744,829,'16-MAY-2022',TO_DATE('16-MAY-2022 15:55','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(320,781,827,'16-MAY-2022',TO_DATE('16-MAY-2022 20:13','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(320,736,820,'16-MAY-2022',TO_DATE('16-MAY-2022 21:0','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(326,790,824,'16-MAY-2022',TO_DATE('16-MAY-2022 0:51','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(337,745,828,'16-MAY-2022',TO_DATE('16-MAY-2022 9:38','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(372,743,820,'16-MAY-2022',TO_DATE('16-MAY-2022 21:57','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(372,745,823,'16-MAY-2022',TO_DATE('16-MAY-2022 8:8','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(372,743,823,'16-MAY-2022',TO_DATE('16-MAY-2022 9:18','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(389,744,821,'16-MAY-2022',TO_DATE('16-MAY-2022 19:44','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(389,798,827,'16-MAY-2022',TO_DATE('16-MAY-2022 9:14','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(389,744,822,'16-MAY-2022',TO_DATE('16-MAY-2022 23:41','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(399,798,824,'16-MAY-2022',TO_DATE('16-MAY-2022 2:29','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(399,745,824,'16-MAY-2022',TO_DATE('16-MAY-2022 22:31','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(413,781,822,'16-MAY-2022',TO_DATE('16-MAY-2022 21:51','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(413,781,827,'16-MAY-2022',TO_DATE('16-MAY-2022 14:27','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(416,743,823,'16-MAY-2022',TO_DATE('16-MAY-2022 19:18','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(416,745,826,'16-MAY-2022',TO_DATE('16-MAY-2022 2:57','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(137,761,837,'16-MAY-2022',TO_DATE('16-MAY-2022 3:33','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(137,761,837,'16-MAY-2022',TO_DATE('16-MAY-2022 9:54','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(137,762,837,'16-MAY-2022',TO_DATE('16-MAY-2022 2:13','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(146,762,831,'16-MAY-2022',TO_DATE('16-MAY-2022 17:40','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(146,761,833,'16-MAY-2022',TO_DATE('16-MAY-2022 10:11','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(150,746,836,'16-MAY-2022',TO_DATE('16-MAY-2022 21:36','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(168,763,837,'16-MAY-2022',TO_DATE('16-MAY-2022 4:33','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(169,746,832,'16-MAY-2022',TO_DATE('16-MAY-2022 3:28','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(201,762,834,'16-MAY-2022',TO_DATE('16-MAY-2022 8:41','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(201,761,834,'16-MAY-2022',TO_DATE('16-MAY-2022 5:44','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(202,761,831,'16-MAY-2022',TO_DATE('16-MAY-2022 22:53','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(212,761,833,'16-MAY-2022',TO_DATE('16-MAY-2022 20:18','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(212,763,833,'16-MAY-2022',TO_DATE('16-MAY-2022 13:38','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(212,746,836,'16-MAY-2022',TO_DATE('16-MAY-2022 20:41','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(218,763,834,'16-MAY-2022',TO_DATE('16-MAY-2022 12:1','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(218,762,834,'16-MAY-2022',TO_DATE('16-MAY-2022 18:45','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(239,762,837,'16-MAY-2022',TO_DATE('16-MAY-2022 17:16','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(239,746,837,'16-MAY-2022',TO_DATE('16-MAY-2022 6:48','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(242,762,837,'16-MAY-2022',TO_DATE('16-MAY-2022 6:16','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(244,762,832,'16-MAY-2022',TO_DATE('16-MAY-2022 10:27','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(261,762,837,'16-MAY-2022',TO_DATE('16-MAY-2022 14:39','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(261,763,837,'16-MAY-2022',TO_DATE('16-MAY-2022 10:28','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(261,762,832,'16-MAY-2022',TO_DATE('16-MAY-2022 13:41','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(278,762,834,'16-MAY-2022',TO_DATE('16-MAY-2022 14:49','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(278,763,834,'16-MAY-2022',TO_DATE('16-MAY-2022 14:13','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(288,746,836,'16-MAY-2022',TO_DATE('16-MAY-2022 9:31','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(288,763,836,'16-MAY-2022',TO_DATE('16-MAY-2022 4:11','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(288,763,836,'16-MAY-2022',TO_DATE('16-MAY-2022 23:42','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(330,763,837,'16-MAY-2022',TO_DATE('16-MAY-2022 21:41','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(345,761,835,'16-MAY-2022',TO_DATE('16-MAY-2022 21:43','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(345,762,833,'16-MAY-2022',TO_DATE('16-MAY-2022 3:59','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(345,761,833,'16-MAY-2022',TO_DATE('16-MAY-2022 10:32','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(347,761,837,'16-MAY-2022',TO_DATE('16-MAY-2022 5:29','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(347,763,832,'16-MAY-2022',TO_DATE('16-MAY-2022 2:9','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(391,762,832,'16-MAY-2022',TO_DATE('16-MAY-2022 3:5','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(391,746,837,'16-MAY-2022',TO_DATE('16-MAY-2022 23:25','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(395,761,831,'16-MAY-2022',TO_DATE('16-MAY-2022 23:22','DD-MON-YYYY HH24:MI'),3);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(395,763,832,'16-MAY-2022',TO_DATE('16-MAY-2022 6:59','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(395,762,837,'16-MAY-2022',TO_DATE('16-MAY-2022 8:46','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(407,762,832,'16-MAY-2022',TO_DATE('16-MAY-2022 12:27','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(407,762,832,'16-MAY-2022',TO_DATE('16-MAY-2022 4:8','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(408,762,833,'16-MAY-2022',TO_DATE('16-MAY-2022 13:31','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(408,746,838,'16-MAY-2022',TO_DATE('16-MAY-2022 5:59','DD-MON-YYYY HH24:MI'),4);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(419,746,837,'16-MAY-2022',TO_DATE('16-MAY-2022 10:32','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(419,749,831,'16-MAY-2022',TO_DATE('16-MAY-2022 5:1','DD-MON-YYYY HH24:MI'),5);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(419,763,832,'16-MAY-2022',TO_DATE('16-MAY-2022 4:58','DD-MON-YYYY HH24:MI'),2);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(424,761,831,'16-MAY-2022',TO_DATE('16-MAY-2022 19:26','DD-MON-YYYY HH24:MI'),4);

commit;

-- 6) Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent 
-- care s? utilizeze dou? tipuri diferite de colec?ii studiate. Apela?i subprogramul. 


-- Specificandu-se un partener (id_part) afisati pentru fiecare gradina zoologica cu care acest partener a interactionat
-- lista angajatilor (id, nume, prenume, ocupatie) care au hranit animale, dar nu sunt ingrijitori.

create or replace procedure angajati_hranesc(id_partener in partener.id_part%type) is
    type ang is record
        (id_ang angajati.id_ang%type,
         nume angajati.nume%type,
         prenume angajati.prenume%type,
         titlu_job jobs.titlu_job%type
        );
    type lista_ang is table of ang;
    type gradzoo is table of lista_ang index by pls_integer;
    type nume_job is table of jobs.titlu_job%type index by varchar2(10);
    no_partner_found exception;
    no_zoo_found exception;
    verificare number(3);
    angajat_job nume_job;
    cursor joburi is
        select id_job, titlu_job
        from jobs;
    cursor gradini_zoo(id_p partener.id_part%type) is
        select distinct id_zoo
        from beneficiaza
        where id_part=id_p;
    cursor cursor_angajati(id_p partener.id_part%type) is
        select distinct a.id_ang, a.nume, a.prenume, a.id_job, a.id_zoo
        from angajati a, hraneste h
        where a.id_zoo in (select distinct id_zoo
                        from beneficiaza
                        where id_part=id_p)
        and h.id_ang=a.id_ang
        and a.id_job!='INGRJ';
    lista_angajati gradzoo;
    aux ang;
    i pls_integer;
    nr_ordine natural;
begin
    select count(*)
    into verificare
    from partener
    where id_part=id_partener;
    
    if verificare = 0 then
        raise no_partner_found;
    end if;
    
    select count(*)
    into verificare
    from beneficiaza
    where id_part=id_partener;
    
    if verificare = 0 then
        raise no_zoo_found;
    end if;
    
    for elem in joburi loop
        angajat_job(elem.id_job) := elem.titlu_job;
    end loop;
    
    for elem in gradini_zoo(id_partener) loop
        lista_angajati(elem.id_zoo) := lista_ang();
    end loop;
    
    for elem in cursor_angajati(id_partener) loop
        aux.id_ang := elem.id_ang;
        aux.nume := elem.nume;
        aux.prenume := elem.prenume;
        aux.titlu_job := angajat_job(elem.id_job);
        lista_angajati(elem.id_zoo).extend;
        lista_angajati(elem.id_zoo)(lista_angajati(elem.id_zoo).last) := aux;
        
    end loop;
    
    dbms_output.put_line('Gradinile zoologice cu care a interactionat partenerul cu id ' || id_partener || ' sunt:');
    dbms_output.new_line;
    dbms_output.new_line;
    
    i:=lista_angajati.first;
    while i<=lista_angajati.last loop
        dbms_output.put_line('------------------------------');
        dbms_output.put_line('Gradina zoologica ' || i);
        dbms_output.put_line('------------------------------');
        
        if lista_angajati(i).count = 0 then
            dbms_output.put_line('Nu exista angajati care au hranit animalele si sa nu fie ingrijitori.');
        else
            nr_ordine := 1;
            for j in lista_angajati(i).first..lista_angajati(i).last loop
                dbms_output.put_line(nr_ordine || ') ' || lista_angajati(i)(j).id_ang || '   ' || lista_angajati(i)(j).prenume || ' ' || lista_angajati(i)(j).nume || '     ' || lista_angajati(i)(j).titlu_job);
                nr_ordine := nr_ordine + 1;
            end loop;
        end if;
        dbms_output.new_line;
        dbms_output.new_line;
        i:=lista_angajati.next(i);
    end loop;
    
    
exception
    when no_partner_found then 
        raise_application_error(-20001, 'Nu exista un partener cu acest id.');
    when no_zoo_found then 
        raise_application_error(-20002, 'Acest partener nu interactioneaza cu nicio gradina zoologica.');
end;
/

declare
    id_partener partener.id_part%type := &v_partener;
begin
    angajati_hranesc(id_partener);
end;
/


-- 7) Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind
-- un subprogram stocat independent care s? utilizeze 2 tipuri diferite de cursoare studiate, 
-- unul dintre acestea fiind cursor parametrizat. Apela?i subprogramul.

-- Dandu-se un produs, sa se afle primele 5 gradini zoo care vand cele mai multe produse si sa se afiseze
-- pentru fiecare,numarul de produse pe care il vand cat si vanzatorii de produse. 

create or replace procedure numar_vanzatori(id_prod in produse.id_produs%type) is
    cursor numar_produse(id_p produse.id_produs%type) is
       select *
       from (select count(*) nr_prod, id_zoo
             from vand
             where id_zoo in (select v.id_zoo
                              from vand v
                              where v.id_produs=id_p)
             group by id_zoo
             order by 1 desc)
       where rownum<=5;
    cursor ang(id_grad gradina_zoologica.id_zoo%type) is
        select prenume, nume
        from angajati
        where id_zoo=id_grad
        and id_job='VANZ_PROD';
    id_z gradina_zoologica.id_zoo%type;
    nr_p number(3);
    no_product_found exception;
    no_product_sold exception;
    verificare number(3);
    nr_ordine natural;
    nr_zoo natural := 0;
begin
    select count(*)
    into verificare
    from produse
    where id_produs = id_prod;
    
    if verificare = 0 then
        raise no_product_found;
    end if;
    
    select count(*)
    into verificare
    from vand
    where id_produs = id_prod;
    
    if verificare = 0 then
        raise no_product_sold;
    end if;
    
    open numar_produse(id_prod);
    loop
        fetch numar_produse into nr_p,id_z;
        exit when numar_produse%notfound;
        dbms_output.put_line('-----------------------------------------------------------------------------------------------');
        dbms_output.put_line('Gradina zoologica ' || id_z || ' vinde ' || nr_p || ' tipuri de produse. Vanzatorii de produse sunt:');
        dbms_output.put_line('-----------------------------------------------------------------------------------------------');
        nr_ordine := 1;
        nr_zoo := nr_zoo +1;
        for elem in ang(id_z) loop
            dbms_output.put_line(nr_ordine || ') ' || elem.prenume || ' ' || elem.nume);
            nr_ordine := nr_ordine + 1;
        end loop;
        dbms_output.new_line;
        dbms_output.new_line;
    end loop;
    close numar_produse;
    if nr_zoo < 5 then
        dbms_output.put_line('Produsul se afla doar in ' || nr_zoo || ' gradini zoologice.');
    end if;
exception
    when no_product_found then 
        raise_application_error(-20001, 'Nu exista un produs cu acest id.');
    when no_product_sold then 
        raise_application_error(-20002, 'Acest produs nu este vandut de nicio gradina zoologica.');
end;
/

declare
    id_produs produse.id_produs%type := &v_produs;
begin
    numar_vanzatori(id_produs);
end;
/


-- 8) Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent de tip func?ie 
-- care s? utilizeze într-o singur? comand? SQL 3 dintre tabelele definite. Defini?i minim 2 excep?ii. 
-- Apela?i subprogramul astfel încât s? eviden?ia?i toate cazurile tratate. 

-- Se da o gradina zoologica (id_zoo). Sa se returneze numele partenerului care a facut cele mai multe donatii catre
-- aceasta gradina zoologica. Sa se trateze exceptiile cand gradina zoo data nu exista, cand exista mai multi parteneri
-- cu numar maxim de donatii si cand nu exista nicio donatie catre gradina zoo.

create or replace function donator_maxim(id_z gradina_zoologica.id_zoo%type)
return partener.nume_partener%type is
    nume partener.nume_partener%type;
    no_zoo_found exception;
    verificare number(1);
begin
    select count(*)
    into verificare
    from gradina_zoologica
    where id_zoo=id_z;
    
    if verificare = 0 then
        raise no_zoo_found;
    end if;
    
    select p.nume_partener
    into nume
--    from beneficiaza b join partener p on (b.id_part = p.id_part) join serviciu s on (b.id_serviciu = s.id_serviciu)
    from beneficiaza b, partener p, serviciu s
    where b.id_zoo=id_z
    and b.id_part = p.id_part
    and b.id_serviciu = s.id_serviciu
    and s.tip_serviciu = 'Donatie'
    group by p.nume_partener
    having count(*) = (select max(count(*))
                        from beneficiaza b, serviciu s
                        where b.id_zoo=id_z
                        and b.id_serviciu = s.id_serviciu
                        and s.tip_serviciu = 'Donatie'
                        group by b.id_part);
    
    return nume;
exception
    when no_zoo_found then 
        raise_application_error(-20001, 'Nu exista o gradina zoologica cu acest id.');
    when no_data_found then 
        raise_application_error(-20002, 'Aceasta gradina zoologica nu a primit nicio donatie.');
    when too_many_rows then 
        raise_application_error(-20003, 'Prea multi parteneri cu donatii maxime.');
end;
/

declare
    id_z gradina_zoologica.id_zoo%type := &v_zoo;
    nume partener.nume_partener%type;
begin
    nume := donator_maxim(id_z);
    dbms_output.put_line(nume);
end;
/



-- 9) Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent de tip procedur? 
-- care s? utilizeze într-o singur? comand? SQL 5 dintre tabelele definite. Trata?i toate excep?iile care pot ap?rea, 
-- incluzând excep?iile NO_DATA_FOUND ?i TOO_MANY_ROWS. Apela?i subprogramul astfel încât s? eviden?ia?i toate cazurile tratate. 

-- Dandu-se o gradina zoologica (id_zoo), sa se afle cea mai comuna specie de animale din aceasta. Apoi sa se afiseze
-- animalele care fac parte din aceasta specie (nu si din aceasta gradina zoologica) care , in ziua de 16 mai 2022, 
-- au fost hranite in afara intervalului orar 08:00 - 14:00 cu un tip de hrana ce este valabil 2 saptamani de la cumparare, 
-- de catre un angajat care castiga mai putin decat salariul mediu al job-ului sau, adica media dintre salariul minim si maxim al job-ului.
-- Sa se trateze cazurile cand id_zoo nu exista, cand in gradina zoo sunt mai multe specii comune sau cand gradina zoo
-- inca nu adaposteste animale.

create or replace procedure animale_specie(id_z in gradina_zoologica.id_zoo%type) is
    type animal is record
        (id_animal animale.id_animal%type,
         nume animale.nume%type,
         varsta animale.varsta%type,
         id_zoo gradina_zoologica.id_zoo%type,
         temperament animale.temperament%type
        );
    type lista_animale is table of animal index by pls_integer;
    lista_ani lista_animale;
    sp specie.id_specie%type;
    no_zoo_found exception;
    verificare number(1);
    nr_ordine natural := 1;
begin
    begin
        select count(*)
        into verificare
        from gradina_zoologica
        where id_zoo=id_z;
        
        if verificare = 0 then
            raise no_zoo_found;
        end if;
        
        select id_specie
        into sp
        from animale
        where id_zoo = id_z
        group by id_specie
        having count(*) = (select max(count(*))
                            from animale
                            where id_zoo = id_z
                            group by id_specie);
        
    exception
        when no_zoo_found then 
            raise_application_error(-20001, 'Nu exista o gradina zoologica cu acest id.');
        when no_data_found then 
            raise_application_error(-20002, 'Aceasta gradina zoologica nu adaposteste inca niciun animal.');
        when too_many_rows then 
            raise_application_error(-20003, 'Prea multe specii comune.');
    end;
    
    select ani.id_animal, ani.nume, ani.varsta, ani.id_zoo, ani.temperament
    bulk collect into lista_ani
    from animale ani,hrana hr, angajati ang, hraneste hran,tip_hrana t
    where ani.id_animal=hran.id_animal
    and ang.id_ang=hran.id_ang
    and hr.id_hrana=hran.id_hrana
    and hr.id_tip_hrana=t.id_tip_hrana
    and hran.data_hranire='16-MAY-22'
    and t.sapt_valabilitate = 2
    and ani.id_specie=sp
    and (to_char(hran.ora_hranire,'HH24:MI')>'14:00' or to_char(hran.ora_hranire,'HH24:MI')<'08:00')
    and ang.id_ang in (select a.id_ang 
                        from angajati a
                        where a.salariu <=(select (salariu_max+salariu_min)/2
                                                 from jobs
                                                 where a.id_job=id_job));
    
    dbms_output.put_line('Specia comuna este ' || sp);
    
    for i in lista_ani.first..lista_ani.last loop
        dbms_output.put_line(nr_ordine || ') ID ' || lista_ani(i).id_animal || ', ' || lista_ani(i).nume || ', are ' || lista_ani(i).varsta || ' ani, se afla la gradina zoo ' || lista_ani(i).id_zoo || ' si este ' || lista_ani(i).temperament);
        nr_ordine := nr_ordine +1;
    end loop;
end;
/

declare
    id_z gradina_zoologica.id_zoo%type := &v_zoo;
begin
    animale_specie(id_z);
end;
/


-- 10) Defini?i un trigger de tip LMD la nivel de comand?. Declan?a?i trigger-ul. 

-- Sa se creeze un trigger care la nivel de comanda care actualizeaza tabelul numar_hrana, ce contine
-- informatii despre cate tipuri de hrana are fiecare gradina zoologica.

create or replace trigger update_hrana
    after insert or delete on hrana
begin
    for elem in (select id_zoo,count(*) nr
                from hrana
                group by id_zoo) loop
        update numar_hrana
        set nr = elem.nr
        where id_zoo = elem.id_zoo;
        
        if sql%notfound then
            insert into numar_hrana(id_zoo,nr)
            values(elem.id_zoo,elem.nr);
        end if;
    end loop;
end;
/

delete from hrana
where id_hrana = 700
and id_zoo = 1;

insert into HRANA(id_hrana,cantitate,id_zoo,id_tip_hrana)
values(700,430,1,'CER_SP');

select *
from hrana
where id_zoo=1;

select * 
from numar_hrana;

-- 11) Defini?i un trigger de tip LMD la nivel de linie. Declan?a?i trigger-ul. 

-- Sa se creeze un trigger care nu permite inserarea unei inregistrari de hranire a unui animal, daca
-- acesta are restrictie de interzicere hrana, in interiorul perioadei de restrictie.

create or replace trigger hraneste_animal
    before insert on hraneste
    for each row
declare
    verificare number(1);
begin
    select count(*) 
    into verificare
    from restrictie
    where tip_restrictie = 'INT_HR'
    and id_animal = :new.id_animal
    and :new.data_hranire BETWEEN data_inceput and data_sfarsit;
    
    if verificare != 0 then
        raise_application_error(-20001, 'Animalul are restrictie de interzicere a hranii.');
    end if;
end;
/

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(354,783,707,'16-APR-2013',TO_DATE('16-APR-2013 17:31','DD-MON-YYYY HH24:MI'),1);

insert into HRANESTE(id_animal,id_ang,id_hrana,data_hranire,ora_hranire,cantitate)
values(354,783,707,'16-APR-2014',TO_DATE('16-APR-2014 17:31','DD-MON-YYYY HH24:MI'),1);

select *
from restrictie
where tip_restrictie = 'INT_HR'
and id_animal=354;


-- 12) Defini?i un trigger de tip LDD. Declan?a?i trigger-ul.  

-- Sa se creeze un trigger care introduce in tabela evenimente detalii despre comanda LDD executata.

create or replace trigger detalii
    after create or drop or alter on schema
begin
    insert into evenimente(username, data_eveniment, actiune, nume)
    values(user,sysdate,ora_sysevent,ora_dict_obj_name);
end;
/

select * 
from evenimente;



-- 13) Defini?i un pachet care s? con?in? toate obiectele definite în cadrul proiectului. 

create or replace package gradini_zoo is
    procedure angajati_hranesc(id_partener in partener.id_part%type);
    procedure numar_vanzatori(id_prod in produse.id_produs%type);
    function donator_maxim(id_z gradina_zoologica.id_zoo%type)
    return partener.nume_partener%type;
    procedure animale_specie(id_z in gradina_zoologica.id_zoo%type);
end;
/

create or replace package body gradini_zoo is
    procedure angajati_hranesc(id_partener in partener.id_part%type) is
        type ang is record
            (id_ang angajati.id_ang%type,
             nume angajati.nume%type,
             prenume angajati.prenume%type,
             titlu_job jobs.titlu_job%type
            );
        type lista_ang is table of ang;
        type gradzoo is table of lista_ang index by pls_integer;
        type nume_job is table of jobs.titlu_job%type index by varchar2(10);
        no_partner_found exception;
        no_zoo_found exception;
        verificare number(3);
        angajat_job nume_job;
        cursor joburi is
            select id_job, titlu_job
            from jobs;
        cursor gradini_zoo(id_p partener.id_part%type) is
            select distinct id_zoo
            from beneficiaza
            where id_part=id_p;
        cursor cursor_angajati(id_p partener.id_part%type) is
            select distinct a.id_ang, a.nume, a.prenume, a.id_job, a.id_zoo
            from angajati a, hraneste h
            where a.id_zoo in (select distinct id_zoo
                            from beneficiaza
                            where id_part=id_p)
            and h.id_ang=a.id_ang
            and a.id_job!='INGRJ';
        lista_angajati gradzoo;
        aux ang;
        i pls_integer;
        nr_ordine natural;
    begin
        select count(*)
        into verificare
        from partener
        where id_part=id_partener;
        
        if verificare = 0 then
            raise no_partner_found;
        end if;
        
        select count(*)
        into verificare
        from beneficiaza
        where id_part=id_partener;
        
        if verificare = 0 then
            raise no_zoo_found;
        end if;
        
        for elem in joburi loop
            angajat_job(elem.id_job) := elem.titlu_job;
        end loop;
        
        for elem in gradini_zoo(id_partener) loop
            lista_angajati(elem.id_zoo) := lista_ang();
        end loop;
        
        for elem in cursor_angajati(id_partener) loop
            aux.id_ang := elem.id_ang;
            aux.nume := elem.nume;
            aux.prenume := elem.prenume;
            aux.titlu_job := angajat_job(elem.id_job);
            lista_angajati(elem.id_zoo).extend;
            lista_angajati(elem.id_zoo)(lista_angajati(elem.id_zoo).last) := aux;
            
        end loop;
        
        dbms_output.put_line('Gradinile zoologice cu care a interactionat partenerul cu id ' || id_partener || ' sunt:');
        dbms_output.new_line;
        dbms_output.new_line;
        
        i:=lista_angajati.first;
        while i<=lista_angajati.last loop
            dbms_output.put_line('------------------------------');
            dbms_output.put_line('Gradina zoologica ' || i);
            dbms_output.put_line('------------------------------');
            
            if lista_angajati(i).count = 0 then
                dbms_output.put_line('Nu exista angajati care au hranit animalele si sa nu fie ingrijitori.');
            else
                nr_ordine := 1;
                for j in lista_angajati(i).first..lista_angajati(i).last loop
                    dbms_output.put_line(nr_ordine || ') ' || lista_angajati(i)(j).id_ang || '   ' || lista_angajati(i)(j).prenume || ' ' || lista_angajati(i)(j).nume || '     ' || lista_angajati(i)(j).titlu_job);
                    nr_ordine := nr_ordine + 1;
                end loop;
            end if;
            dbms_output.new_line;
            dbms_output.new_line;
            i:=lista_angajati.next(i);
        end loop;
        
        
    exception
        when no_partner_found then 
            raise_application_error(-20001, 'Nu exista un partener cu acest id.');
        when no_zoo_found then 
            raise_application_error(-20002, 'Acest partener nu interactioneaza cu nicio gradina zoologica.');
    end;
    
    procedure numar_vanzatori(id_prod in produse.id_produs%type) is
        cursor numar_produse(id_p produse.id_produs%type) is
           select *
           from (select count(*) nr_prod, id_zoo
                 from vand
                 where id_zoo in (select v.id_zoo
                                  from vand v
                                  where v.id_produs=id_p)
                 group by id_zoo
                 order by 1 desc)
           where rownum<=5;
        cursor ang(id_grad gradina_zoologica.id_zoo%type) is
            select prenume, nume
            from angajati
            where id_zoo=id_grad
            and id_job='VANZ_PROD';
        id_z gradina_zoologica.id_zoo%type;
        nr_p number(3);
        no_product_found exception;
        no_product_sold exception;
        verificare number(3);
        nr_ordine natural;
        nr_zoo natural := 0;
    begin
        select count(*)
        into verificare
        from produse
        where id_produs = id_prod;
        
        if verificare = 0 then
            raise no_product_found;
        end if;
        
        select count(*)
        into verificare
        from vand
        where id_produs = id_prod;
        
        if verificare = 0 then
            raise no_product_sold;
        end if;
        
        open numar_produse(id_prod);
        loop
            fetch numar_produse into nr_p,id_z;
            exit when numar_produse%notfound;
            dbms_output.put_line('-----------------------------------------------------------------------------------------------');
            dbms_output.put_line('Gradina zoologica ' || id_z || ' vinde ' || nr_p || ' tipuri de produse. Vanzatorii de produse sunt:');
            dbms_output.put_line('-----------------------------------------------------------------------------------------------');
            nr_ordine := 1;
            nr_zoo := nr_zoo +1;
            for elem in ang(id_z) loop
                dbms_output.put_line(nr_ordine || ') ' || elem.prenume || ' ' || elem.nume);
                nr_ordine := nr_ordine + 1;
            end loop;
            dbms_output.new_line;
            dbms_output.new_line;
        end loop;
        close numar_produse;
        if nr_zoo < 5 then
            dbms_output.put_line('Produsul se afla doar in ' || nr_zoo || ' gradini zoologice.');
        end if;
    exception
        when no_product_found then 
            raise_application_error(-20001, 'Nu exista un produs cu acest id.');
        when no_product_sold then 
            raise_application_error(-20002, 'Acest produs nu este vandut de nicio gradina zoologica.');
    end;
    
    function donator_maxim(id_z gradina_zoologica.id_zoo%type)
    return partener.nume_partener%type is
        nume partener.nume_partener%type;
        no_zoo_found exception;
        verificare number(1);
    begin
        select count(*)
        into verificare
        from gradina_zoologica
        where id_zoo=id_z;
        
        if verificare = 0 then
            raise no_zoo_found;
        end if;
        
        select p.nume_partener
        into nume
        from beneficiaza b, partener p, serviciu s
        where b.id_zoo=id_z
        and b.id_part = p.id_part
        and b.id_serviciu = s.id_serviciu
        and s.tip_serviciu = 'Donatie'
        group by p.nume_partener
        having count(*) = (select max(count(*))
                            from beneficiaza b, serviciu s
                            where b.id_zoo=id_z
                            and b.id_serviciu = s.id_serviciu
                            and s.tip_serviciu = 'Donatie'
                            group by b.id_part);
        
        return nume;
    exception
        when no_zoo_found then 
            raise_application_error(-20001, 'Nu exista o gradina zoologica cu acest id.');
        when no_data_found then 
            raise_application_error(-20002, 'Aceasta gradina zoologica nu a primit nicio donatie.');
        when too_many_rows then 
            raise_application_error(-20003, 'Prea multi parteneri cu donatii maxime.');
    end;
    
    procedure animale_specie(id_z in gradina_zoologica.id_zoo%type) is
        type animal is record
            (id_animal animale.id_animal%type,
             nume animale.nume%type,
             varsta animale.varsta%type,
             id_zoo gradina_zoologica.id_zoo%type,
             temperament animale.temperament%type
            );
        type lista_animale is table of animal index by pls_integer;
        lista_ani lista_animale;
        sp specie.id_specie%type;
        no_zoo_found exception;
        verificare number(1);
        nr_ordine natural := 1;
    begin
        begin
            select count(*)
            into verificare
            from gradina_zoologica
            where id_zoo=id_z;
            
            if verificare = 0 then
                raise no_zoo_found;
            end if;
            
            select id_specie
            into sp
            from animale
            where id_zoo = id_z
            group by id_specie
            having count(*) = (select max(count(*))
                                from animale
                                where id_zoo = id_z
                                group by id_specie);
            
        exception
            when no_zoo_found then 
                raise_application_error(-20001, 'Nu exista o gradina zoologica cu acest id.');
            when no_data_found then 
                raise_application_error(-20002, 'Aceasta gradina zoologica nu adaposteste inca niciun animal.');
            when too_many_rows then 
                raise_application_error(-20003, 'Prea multe specii comune.');
        end;
        
        select ani.id_animal, ani.nume, ani.varsta, ani.id_zoo, ani.temperament
        bulk collect into lista_ani
        from animale ani,hrana hr, angajati ang, hraneste hran,tip_hrana t
        where ani.id_animal=hran.id_animal
        and ang.id_ang=hran.id_ang
        and hr.id_hrana=hran.id_hrana
        and hr.id_tip_hrana=t.id_tip_hrana
        and hran.data_hranire='16-MAY-22'
        and t.sapt_valabilitate = 2
        and ani.id_specie=sp
        and (to_char(hran.ora_hranire,'HH24:MI')>'14:00' or to_char(hran.ora_hranire,'HH24:MI')<'08:00')
        and ang.id_ang in (select a.id_ang 
                            from angajati a
                            where a.salariu <=(select (salariu_max+salariu_min)/2
                                                     from jobs
                                                     where a.id_job=id_job));
        
        dbms_output.put_line('Specia comuna este ' || sp);
        
        for i in lista_ani.first..lista_ani.last loop
            dbms_output.put_line(nr_ordine || ') ID ' || lista_ani(i).id_animal || ', ' || lista_ani(i).nume || ', are ' || lista_ani(i).varsta || ' ani, se afla la gradina zoo ' || lista_ani(i).id_zoo || ' si este ' || lista_ani(i).temperament);
            nr_ordine := nr_ordine +1;
        end loop;
    end;
end;
/

begin
    gradini_zoo.animale_specie(2);
end;
/


-- 14) Defini?i un pachet care s? includ? tipuri de date complexe ?i obiecte necesare unui flux de ac?iuni integrate, 
-- specifice bazei de date definite (minim 2 tipuri de date, minim 2 func?ii, minim 2 proceduri). 

create or replace package conducere_zoo is
    type specie_animal is record
        (id_specie specie.id_specie%type,
         nume_specie specie.nume_specie%type,
         tip_dieta specie.tip_dieta%type
        );
    type lista_specii is table of specie_animal index by pls_integer;
    type restrictie_animal is record
        (nume animale.nume%type,
         data_inceput restrictie.data_inceput%type,
         data_sfarsit restrictie.data_sfarsit%type,
         nume_restrictie tip_restrictie.nume_restrictie%type
        );
    type lista_restrictii is table of restrictie_animal index by pls_integer;
    -- Sa se returneze speciile de care are grija un ingrijitor dat
    function angajat_specii(id_angajat angajati.id_ang%type)
    return lista_specii;
    -- Sa se returneze cantitatea mancata de un animal dat, intr-o zi data
    function cantitate(zi date, id_ani animale.id_animal%type)
    return number;
    -- Sa se afiseze restrictiile impuse asupra animalelor dintr-o gradina zoo data 
    procedure restrictii_animale(id_z in gradina_zoologica.id_zoo%type);
    -- Sa se afiseze cate tipuri de hrana provin din tara data
    procedure provine(tara tip_hrana.origine%type);
end;
/

create or replace package body conducere_zoo is
    function angajat_specii(id_angajat angajati.id_ang%type)
    return lista_specii is
        no_zookeeper_found exception;
        verificare number(1);
        lista lista_specii;
        aux specie_animal;
        indice natural := 1;
    begin
        select count(*)
        into verificare
        from angajati
        where id_ang=id_angajat
        and id_job = 'INGRJ';
        
        if verificare = 0 then
            raise no_zookeeper_found;
        end if;
        
        for elem in (select distinct s.id_specie, s.nume_specie, s.tip_dieta 
                    from hraneste h, specie s, animale a
                    where h.id_ang=783
                    and h.id_animal=a.id_animal
                    and a.id_specie=s.id_specie) loop
            aux.id_specie := elem.id_specie;
            aux.nume_specie := elem.nume_specie;
            aux.tip_dieta := elem.tip_dieta;
            lista(indice) := aux;
            indice := indice + 1;
        end loop;
        
        return lista;
        
    exception
        when no_zookeeper_found then 
            raise_application_error(-20001, 'Angajatul nu este ingrijitor.');
    end;
    
    function cantitate(zi date, id_ani animale.id_animal%type)
    return number is
        cant number;
        verificare number;
        no_animal_found exception;
        no_feeding_found exception;
    begin
        select count(*)
        into cant
        from animale
        where id_animal=id_ani;
        
        if cant = 0 then
            raise no_animal_found;
        end if;
        
        select sum(cantitate),count(cantitate)
        into cant,verificare
        from hraneste
        where data_hranire = zi
        and id_animal=id_ani;
        
        if verificare = 0 then
            raise no_feeding_found;
        end if;
        
        return cant;
    exception
        when no_feeding_found then 
            raise_application_error(-20001, 'Animalul nu a fost hranit in ziua respectiva');
        when no_animal_found then 
            raise_application_error(-20002, 'Nu exista un animal cu acest id');
    end;
    
    procedure restrictii_animale(id_z in gradina_zoologica.id_zoo%type) is
        lista lista_restrictii;
        no_zoo_found exception;
        verificare number(1);
    begin
        select count(*)
        into verificare
        from gradina_zoologica
        where id_zoo=id_z;
        
        if verificare = 0 then
            raise no_zoo_found;
        end if;
        
        select a.nume,r.data_inceput,r.data_sfarsit,t.nume_restrictie
        bulk collect into lista
        from restrictie r, animale a, tip_restrictie t
        where r.id_animal=a.id_animal
        and a.id_zoo=id_z
        and r.tip_restrictie=t.tip_restrictie
        order by a.nume;
        
        if lista.count() = 0 then
            raise no_data_found;
        end if;
        
        for i in lista.first..lista.last loop
            dbms_output.put_line(lista(i).nume || ' ' || lista(i).nume_restrictie || ' ' || lista(i).data_inceput || '-' || lista(i).data_sfarsit);
        end loop;
        
    exception
        when no_zoo_found then 
            raise_application_error(-20001, 'Nu exista o gradina zoologica cu acest id.');
        when no_data_found then
            raise_application_error(-20001, 'Nu exista restrictii.');
    end;
    
    procedure provine(tara tip_hrana.origine%type) is
        cant number(3);
        no_country_found exception;
    begin
        select count(*)
        into cant
        from tip_hrana
        where lower(origine)=lower(tara);
        
        if cant = 0 then
            raise no_country_found;
        else
            dbms_output.put_line('Din ' || tara || ' provin ' || cant || ' tipuri de hrana.');
        end if;
            
    exception
        when no_country_found then
            raise_application_error(-20001, 'Nu exista hrana din aceasta tara');
    end;
end;
/


declare
    lista conducere_zoo.lista_specii;
    cantitate number;
begin
    lista := conducere_zoo.angajat_specii(786);
    
    for elem in lista.first..lista.last loop
        dbms_output.put_line(lista(elem).id_specie || ' ' ||  lista(elem).nume_specie || ' ' || lista(elem).tip_dieta);
    end loop;

--    cantitate := conducere_zoo.cantitate(to_date('16-MAY-22','DD-MON-YY'), 386);
--    dbms_output.put_line('Cantitate: ' || cantitate);
    
--    conducere_zoo.restrictii_animale(16);

--    conducere_zoo.provine('Chile');
end;
/
