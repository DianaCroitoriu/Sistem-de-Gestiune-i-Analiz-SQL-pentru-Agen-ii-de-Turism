DROP TABLE IF EXISTS rezervari_sejururi;
DROP TABLE IF EXISTS rezervari_circuite;
DROP TABLE IF EXISTS incasari_rezervari;
DROP TABLE IF EXISTS cazari_circuite;
DROP TABLE IF EXISTS transporturi_circuite;
DROP TABLE IF EXISTS obiective_turistice_circuite;
DROP TABLE IF EXISTS sejururi;
DROP TABLE IF EXISTS incasari;
DROP TABLE IF EXISTS rezervari;
DROP TABLE IF EXISTS camere_hotel;
DROP TABLE IF EXISTS transporturi;
DROP TABLE IF EXISTS obiective_turistice;
DROP TABLE IF EXISTS circuite_turistice;
DROP TABLE IF EXISTS telefoane_persoane;
DROP TABLE IF EXISTS contacte_email_parteneri;
DROP TABLE IF EXISTS contacte_telefon_parteneri;
DROP TABLE IF EXISTS angajati;
DROP TABLE IF EXISTS hoteluri;
DROP TABLE IF EXISTS parteneri;
DROP TABLE IF EXISTS persoane;
DROP TABLE IF EXISTS localitati;
DROP TABLE IF EXISTS tari;

CREATE TABLE tari(
	idtara NUMERIC(5)
		CONSTRAINT pk_idtara PRIMARY KEY,
	numetara VARCHAR(30)
		CONSTRAINT nn_numetara NOT NULL
		CONSTRAINT un_numetara UNIQUE,
	continent VARCHAR(30)
		CONSTRAINT nn_continent NOT NULL
		CONSTRAINT ck_continent CHECK (continent 
		IN ('Europa', 'America de Nord', 'America de Sud','Australia', 'Asia', 'Africa', 'Antarctica')),
	populatie NUMERIC(10),
	clima VARCHAR(100),
	limbivorbita VARCHAR(100)
);

CREATE TABLE localitati(
	idlocalitate NUMERIC(10)
		CONSTRAINT pk_idlocalitate PRIMARY KEY,
	numelocalitate VARCHAR(70)
		CONSTRAINT nn_numelocalitate NOT NULL,
	regiune VARCHAR(70),
	idtara NUMERIC(5)
		CONSTRAINT nn_idtara NOT NULL
		CONSTRAINT fk_localitati_idtara REFERENCES tari(idtara)
				ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE persoane(
	idpersoana NUMERIC(10)
		CONSTRAINT pk_idpersoana PRIMARY KEY,
	numepersoana VARCHAR(20)
		CONSTRAINT nn_numepersoana NOT NULL
		-- prima litera sa fie litera mare
		CONSTRAINT ck_numepersoana CHECK (SUBSTR(numepersoana,1,1) = UPPER(SUBSTR(numepersoana,1,1))),
	prenumepersoana VARCHAR(30)
		CONSTRAINT nn_prenumepersoana NOT NULL
		-- prima litera sa fie litera mare
		CONSTRAINT ck_prenumepersoana CHECK (SUBSTR(prenumepersoana,1,1) = UPPER(SUBSTR(prenumepersoana,1,1))),
	nationalitate VARCHAR(20),
	idlocalitatepersoana NUMERIC(10)
		CONSTRAINT nn_idlocalitatepersoana NOT NULL
		CONSTRAINT fk_persoane_idlocalitatepersoana REFERENCES localitati(idlocalitate)
				ON DELETE RESTRICT ON UPDATE CASCADE,
	email_persoana VARCHAR(50) -- prea scurt 20
		CONSTRAINT ck_email_persoana CHECK (email_persoana LIKE '%@%.%')
);


CREATE TABLE parteneri(
	idpartener NUMERIC(10)
		CONSTRAINT pk_idpartener PRIMARY KEY,
	numepartener VARCHAR(40),
	adresapartener VARCHAR(100),
	sitewebpartener VARCHAR(25),
	-- era 5 l am schimbat in 10
	id_loc_partener NUMERIC(10)
		CONSTRAINT fk_p_idlocalitatepersoana REFERENCES localitati(idlocalitate)
				ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE hoteluri(
	idhotel NUMERIC(10)
		CONSTRAINT pk_idhotel PRIMARY KEY,
	idpartener NUMERIC(10)
		CONSTRAINT nn_idpartener NOT NULL
		CONSTRAINT fk_hoteluri_idpartener REFERENCES parteneri(idpartener)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	numehotel VARCHAR(50)
		CONSTRAINT nn_numehotel NOT NULL,
	facilitati VARCHAR(250),
	nr_stele INT2,
	cotare VARCHAR(15),
	idlocalitate NUMERIC(10)
		CONSTRAINT nn_idlocalitate NOT NULL
		CONSTRAINT fk_hoteluri_idlocalitate REFERENCES localitati(idlocalitate)
				ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE angajati(
	idangajat NUMERIC(10)
		CONSTRAINT pk_idangajat PRIMARY KEY
		-- cascade la delete pt relatie 1:1
		CONSTRAINT fk_angajati_idangajat REFERENCES persoane(idpersoana)
			ON DELETE CASCADE ON UPDATE CASCADE,
	departament VARCHAR(20),
	functie VARCHAR(25),
	marcasef NUMERIC(2),
	salariu NUMERIC(10)
		CONSTRAINT ck_salariu CHECK (salariu >= 0)
);

CREATE TABLE contacte_telefon_parteneri(
	telefonpartener VARCHAR(20)
		CONSTRAINT pk_telefonpartener PRIMARY KEY,
	idpartener NUMERIC(10)
		CONSTRAINT nn_idpartener_tel NOT NULL
		-- daca stergi un partener sa se stearga toate datele despre ei
		CONSTRAINT fk_contacte_telefon_parteneri_idpartener REFERENCES parteneri(idpartener)
			ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contacte_email_parteneri(
	e_mailpartener VARCHAR(50)
		CONSTRAINT pk_e_mailpartener PRIMARY KEY
		CONSTRAINT ck_e_mailpartener CHECK (e_mailpartener LIKE '%@%.%'),
	idpartener NUMERIC(10)
		CONSTRAINT nn_idpartener NOT NULL
		-- daca stergi un partener sa se stearga toate datele despre ei
		CONSTRAINT fk_contacte_email_parteneri_idpartener REFERENCES parteneri(idpartener)
			ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE telefoane_persoane(
	nrtelefonpersoana VARCHAR(20)
		CONSTRAINT pk_nrtelefonpersoana PRIMARY KEY,
	idpersoana NUMERIC(10)
		CONSTRAINT nn_idpersoana NOT NULL
		CONSTRAINT fk_telefoane_persoane_idpersoana REFERENCES persoane(idpersoana)
			ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE circuite_turistice(
	idcircuitturistic NUMERIC(10)
		CONSTRAINT pk_idcircuitturistic PRIMARY KEY,
	nume_circuit_turistic VARCHAR(500),
	dataplecarii DATE
		CONSTRAINT nn_dataplecarii NOT NULL
		CONSTRAINT ck_dataplecarii CHECK (dataplecarii >= TO_DATE('01-01-2017', 'DD-MM-YYYY') 
       		AND dataplecarii <= TO_DATE('31-12-2026', 'DD-MM-YYYY')),
	datasosirii DATE
		CONSTRAINT nn_datasosirii NOT NULL
		CONSTRAINT ck_datasosirii CHECK (datasosirii >= TO_DATE('01-01-2017', 'DD-MM-YYYY') 
       		AND datasosirii <= TO_DATE('31-12-2026', 'DD-MM-YYYY')),
	tarifcircuit NUMERIC(10)
		CONSTRAINT ck_tarifcircuit CHECK (tarifcircuit >= 0),
	descrierecircuit VARCHAR(100),
	nrmijloacetransport NUMERIC(2)
		CONSTRAINT ck_nrmijloacetransport CHECK (nrmijloacetransport >= 0),
	nrobiectiveturistice NUMERIC(2)
		CONSTRAINT ck_nrobiectiveturistice CHECK (nrobiectiveturistice >= 0),
	nrcamerezervate NUMERIC(2)
		CONSTRAINT ck_nrcamerezervate CHECK (nrcamerezervate >= 0),

		CONSTRAINT ck_sosire_plecare CHECK (dataplecarii >= datasosirii)
);

CREATE TABLE obiective_turistice(
	idobiectiv NUMERIC(7)
		CONSTRAINT pk_idobiectiv PRIMARY KEY,
	numeobiectiv VARCHAR(50),
	adresaobiectiv VARCHAR(50),
	idlocalitate NUMERIC(10)
		CONSTRAINT nn_idlocalitate NOT NULL
		CONSTRAINT fk_obiective_turistice_idlocalitate REFERENCES localitati(idlocalitate)
			ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE transporturi(
	idtransport NUMERIC(10)
		CONSTRAINT pk_idtransport PRIMARY KEY,
	idpartener NUMERIC(10)
		CONSTRAINT nn_idpartener NOT NULL
		CONSTRAINT fk_transporturi_idpartener REFERENCES parteneri(idpartener)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	tiptransport VARCHAR(15),
	modelmijloctransport VARCHAR(20),
	detalii VARCHAR(100)
);

CREATE TABLE camere_hotel(
	idcamera NUMERIC(10)
		CONSTRAINT pk_idcamera PRIMARY KEY,
	nrcamera NUMERIC(4)
		CONSTRAINT ck_nrcamera CHECK (nrcamera >0),
	idhotel NUMERIC(10)
	-- daca se inchide hotelul sa fie sterse toate camerele lui
		CONSTRAINT fk_camere_hotel_idhotel REFERENCES hoteluri(idhotel)
			ON DELETE CASCADE ON UPDATE CASCADE,
	tipcamera VARCHAR(100),
	nrpaturi NUMERIC(2)
		CONSTRAINT ck_nrpaturi CHECK (nrpaturi >0),
	pozitionare VARCHAR(100),
	detaliicamera VARCHAR(100)
);

CREATE TABLE rezervari(
	idrezervare NUMERIC(14)
		CONSTRAINT pk_idrezervari PRIMARY KEY,
	dataorarezervarii TIMESTAMP
		CONSTRAINT nn_dataorarezervarii NOT NULL,
	codclient NUMERIC(10)
		CONSTRAINT nn_codclient NOT NULL
		CONSTRAINT fk_rezervari_codclient REFERENCES persoane(idpersoana)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	idpersoanacontact NUMERIC(10)
		CONSTRAINT nn_idpersoanacontact NOT NULL
		CONSTRAINT fk_rezervari_idpersoanacontact REFERENCES angajati(idangajat)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	suma_totala NUMERIC(14,2)
		CONSTRAINT ck_suma_totala CHECK (suma_totala >=0),
	discount NUMERIC(10,2)
);

CREATE TABLE incasari(
	idincasare NUMERIC(15)
		CONSTRAINT pk_idincasare PRIMARY KEY,
	dataoraincasari TIMESTAMP
		CONSTRAINT nn_dataoraincasari NOT NULL,
	tipdocincasare VARCHAR(20)
		CONSTRAINT nn_tipdocincasare NOT NULL,
	serienrdocincasare NUMERIC(6)
		CONSTRAINT nn_serienrdocincasare NOT NULL,
	sumaincasata NUMERIC(14,2)
		CONSTRAINT ck_sumaincasata CHECK (sumaincasata >=0)
);

CREATE TABLE sejururi(
	idsejur NUMERIC(14)
		CONSTRAINT pk_idsejur PRIMARY KEY,
	idcamera NUMERIC(10)
		CONSTRAINT nn_idcamera NOT NULL
		CONSTRAINT fk_sejururi_idcamera REFERENCES camere_hotel(idcamera)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	idtransport NUMERIC(10)
		CONSTRAINT nn_idtransport NOT NULL
		CONSTRAINT fk_sejururi_idtransport REFERENCES transporturi(idtransport)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	dataplecare DATE
		CONSTRAINT nn_dataplecare NOT NULL
		CONSTRAINT ck_dataplecare CHECK (dataplecare>= TO_DATE('01-01-2017', 'DD-MM-YYYY') 
       		AND dataplecare <= TO_DATE('31-12-2026', 'DD-MM-YYYY')),
	datasosire DATE
		CONSTRAINT nn_datasosire NOT NULL
		CONSTRAINT ck_datasosire CHECK (datasosire >= TO_DATE('01-01-2017', 'DD-MM-YYYY') 
       		AND datasosire <= TO_DATE('31-12-2026', 'DD-MM-YYYY')),
	nrpersoane NUMERIC(1)
	-- nu pot fi 0 persoane
		CONSTRAINT ck_nrpersoane CHECK (nrpersoane >0),
	tarifsejur NUMERIC(10)
		CONSTRAINT ck_tarifsejur CHECK (tarifsejur >=0),

		CONSTRAINT ck_sosire_plecare CHECK (dataplecare >= datasosire)
);

CREATE TABLE obiective_turistice_circuite(
	idcircuitturistic NUMERIC(10)
		CONSTRAINT nn_idcircuitturistic NOT NULL
		CONSTRAINT fk_obiective_turistice_circuite_idcircuitturistic REFERENCES circuite_turistice(idcircuitturistic)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	obiectivnr NUMERIC(2),
	idobiectiv NUMERIC(7)
		CONSTRAINT nn_idobiectiv NOT NULL
		CONSTRAINT fk_obiective_turistice_circuite_idobiectiv REFERENCES obiective_turistice(idobiectiv)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	data_ora_inceput TIMESTAMP
		CONSTRAINT nn_data_ora_inceput NOT NULL,
	data_ora_final TIMESTAMP
		CONSTRAINT nn_data_ora_final NOT NULL,
	CONSTRAINT pk_obiective_turistice_circuite PRIMARY KEY (idcircuitturistic,obiectivnr),
	CONSTRAINT ck_perioada_vizita CHECK (data_ora_final >= data_ora_inceput)
);

CREATE TABLE transporturi_circuite(
	idcircuitturistic NUMERIC(10)
		CONSTRAINT nn_idcircuitturistic NOT NULL
		CONSTRAINT fk_transporturi_circuite_idcircuitturistic REFERENCES circuite_turistice(idcircuitturistic)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	mijloctransportnr NUMERIC(2),
	idtransport NUMERIC(10)
		CONSTRAINT nn_idtransport NOT NULL
		CONSTRAINT fk_transporturi_circuite_idtransport REFERENCES transporturi(idtransport)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	data_ora_inceput TIMESTAMP
		CONSTRAINT nn_data_ora_inceput NOT NULL,
	data_ora_final TIMESTAMP
		CONSTRAINT nn_data_ora_final NOT NULL,
	CONSTRAINT pk_transporturi_circuite PRIMARY KEY (idcircuitturistic,mijloctransportnr),
	CONSTRAINT ck_perioada_vizita CHECK (data_ora_final >= data_ora_inceput)
);

CREATE TABLE cazari_circuite(
	idcircuitturistic NUMERIC(10)
		CONSTRAINT nn_idcircuitturistic NOT NULL
		CONSTRAINT fk_cazari_circuite_idcircuitturistic REFERENCES circuite_turistice(idcircuitturistic)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	camerarezervatanr NUMERIC(2),
	idcamera NUMERIC(10)
		CONSTRAINT nn_idcamera NOT NULL
		CONSTRAINT fk_cazari_circuite_idcamera REFERENCES camere_hotel(idcamera)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	data_checkin DATE
		CONSTRAINT nn_data_checkin NOT NULL,
	data_checkout DATE
		CONSTRAINT nn_data_checkout NOT NULL,
	CONSTRAINT pk_cazari_circuite PRIMARY KEY (idcircuitturistic,camerarezervatanr),
	CONSTRAINT ck_checkinout CHECK (data_checkout >= data_checkin)
);

CREATE TABLE incasari_rezervari(
	idincasare NUMERIC(15)
		CONSTRAINT nn_idincasare NOT NULL
		CONSTRAINT fk_incasari_rezervari_idincasare REFERENCES incasari(idincasare)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	idrezervare NUMERIC(14)
		CONSTRAINT nn_idrezervare NOT NULL
		CONSTRAINT fk_incasari_rezervari_idrezervare REFERENCES rezervari(idrezervare)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	transa_rezervare NUMERIC(14,2)
		CONSTRAINT ck_transa_rezervare CHECK (transa_rezervare >=0),
		CONSTRAINT pk_incasari_rezervari PRIMARY KEY (idincasare,idrezervare)
);

CREATE TABLE rezervari_circuite(
	idrezervare NUMERIC(14)
		CONSTRAINT nn_idrezervare NOT NULL
		CONSTRAINT fk_rezervari_circuite_idrezervare REFERENCES rezervari(idrezervare)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	idcircuitturistic NUMERIC(10)
		CONSTRAINT nn_idcircuitturistic NOT NULL
		CONSTRAINT fk_rezervari_circuite_idcircuitturistic REFERENCES circuite_turistice(idcircuitturistic)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	nr_locuri_rezervate INT2,
		CONSTRAINT pk_rezervari_circuite PRIMARY KEY (idrezervare,idcircuitturistic)
);

CREATE TABLE rezervari_sejururi(
	idrezervare NUMERIC(14)
		CONSTRAINT nn_idrezervare NOT NULL
		CONSTRAINT fk_rezervari_sejururi_idrezervare REFERENCES rezervari(idrezervare)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	idsejur NUMERIC(14)
		CONSTRAINT nn_idsejur NOT NULL
		CONSTRAINT fk_rezervari_sejururi_idsejur REFERENCES sejururi(idsejur)
			ON DELETE RESTRICT ON UPDATE CASCADE,
	nr_bilete_sejur INT2,
		CONSTRAINT pk_rezervari_sejururi PRIMARY KEY (idrezervare,idsejur)
);









