-- Tema 1 - Turism 2
-- Turism2.1 În ce luni calendaristice există sejururi pentru anul 2024

SELECT DISTINCT TO_CHAR(datasosire, 'Month') AS luni_calendaristice
FROM sejururi
WHERE datasosire >= TO_DATE('01-01-2024', 'DD-MM-YYYY') 
	AND datasosire <= TO_DATE('31-12-2024', 'DD-MM-YYYY')	


-- Turism2.2 Afișați rezervările pentru sejururile din luna august 2024
SELECT r.idrezervare, s.datasosire
FROM rezervari r
INNER JOIN rezervari_sejururi rs
	ON r.idrezervare = rs.idrezervare
INNER JOIN sejururi s
	ON rs.idsejur = s.idsejur
WHERE s.datasosire >= TO_DATE('01-08-2024', 'DD-MM-YYYY')
	AND s.datasosire <= TO_DATE('31-08-2024', 'DD-MM-YYYY')


-- Turism2.3 Extrageți toți partenerii din Italia. 
SELECT p.numepartener, t.numetara
FROM parteneri p
INNER JOIN localitati l
	ON p.id_loc_partener = l.idlocalitate
INNER JOIN tari t
	ON l.idtara = t.idtara
WHERE t.numetara like 'Italia'

-- Turism2.4 Care dintre persoanele angajate nu sunt și clienți

SELECT p.numepersoana, p.prenumepersoana
FROM persoane p
INNER JOIN angajati a 
	ON p.idpersoana = a.idangajat

EXCEPT

SELECT p.numepersoana, p.prenumepersoana
FROM persoane p
INNER JOIN rezervari r 
	ON p.idpersoana = r.codclient




-- Tema 2 - Turism 2
-- Turism2.5 În câte luni calendaristice există sejururi pentru anul 2024

SELECT COUNT (DISTINCT EXTRACT(MONTH FROM datasosire)) AS nr_luni
FROM sejururi
WHERE datasosire >= TO_DATE('01-01-2024', 'DD-MM-YYYY') 
	AND datasosire <= TO_DATE('31-12-2024', 'DD-MM-YYYY')	


-- Turism2.6 Afișați numărul de sejururi ale clienților români în luna august 2024, 
-- pentru fiecare localitate (a clienților) din România 
SELECT l.numelocalitate, COUNT(rs.idsejur) AS numar_sejururi
FROM sejururi s
INNER JOIN rezervari_sejururi rs
	ON s.idsejur = rs.idsejur
INNER JOIN rezervari r
	ON rs.idrezervare = r.idrezervare
INNER JOIN persoane p
	ON r.codclient = p.idpersoana
INNER JOIN localitati l
	ON p.idlocalitatepersoana = l.idlocalitate
INNER JOIN tari t
	ON l.idtara = t.idtara
WHERE t.numetara = 'Romania' 
	AND s.datasosire >= TO_DATE('01-08-2024', 'DD-MM-YYYY')
		AND s.datasosire <= TO_DATE('31-08-2024', 'DD-MM-YYYY')
GROUP BY l.numelocalitate


-- Turism2.7 Pentru fiecare angajat, afișați, pe coloane separate, 
-- încăsările (rezervărilor pentru care au fost persoane de contact) 
-- pentru anii 2018, 2019 și 2020. 

SELECT numepersoana, prenumepersoana,
	SUM(CASE WHEN EXTRACT (YEAR FROM dataoraincasari) = 2018 
		THEN transa_rezervare ELSE 0 END) AS incasari2018,
	SUM(CASE WHEN EXTRACT (YEAR FROM dataoraincasari) = 2019 
		THEN transa_rezervare ELSE 0 END) AS incasari2019,
	SUM(CASE WHEN EXTRACT (YEAR FROM dataoraincasari) = 2020 
		THEN transa_rezervare ELSE 0 END) AS incasari2020
FROM persoane p
INNER JOIN angajati a
	ON p.idpersoana = a.idangajat
INNER JOIN rezervari r
	ON a.idangajat = r.idpersoanacontact
INNER JOIN incasari_rezervari ir
	ON r.idrezervare = ir.idrezervare
INNER JOIN incasari i
	ON ir.idincasare = i.idincasare
GROUP BY p.numepersoana, p.prenumepersoana


-- Turism2.8 Care sunt angajații noștri care nu au acordat clienților lor 
-- niciun discount (până în prezent)? 

SELECT DISTINCT p.numepersoana, p.prenumepersoana
FROM angajati a
INNER JOIN persoane p 
	ON a.idangajat = p.idpersoana
WHERE a.idangajat NOT IN
	(SELECT idpersoanacontact 
    FROM rezervari 
    WHERE discount > 0)


-- Turism2.9 Afișați, pentru anul 2023, încasările pentru fiecare client, 
-- cu subtotal la nivel de lună și un total general
SELECT numepersoana, prenumepersoana, 
		TO_CHAR(dataoraincasari, 'Month') AS luna, 
		SUM(transa_rezervare) AS incasari
FROM persoane p
INNER JOIN rezervari r
	ON p.idpersoana = r.codclient
INNER JOIN incasari_rezervari ir
	ON r.idrezervare = ir.idrezervare
INNER JOIN incasari i
	ON ir.idincasare = i.idincasare 
WHERE dataoraincasari >= TO_DATE('01-01-2023', 'DD-MM-YYYY') 
	AND dataoraincasari <= TO_DATE('31-12-2023', 'DD-MM-YYYY')	
GROUP BY numepersoana, prenumepersoana,
		TO_CHAR(dataoraincasari, 'Month')

UNION

SELECT '~TOTAL', 'GENERAL~~', '~~',SUM(transa_rezervare)
FROM incasari_rezervari ir
INNER JOIN incasari i
	ON ir.idincasare = i.idincasare 
WHERE dataoraincasari >= TO_DATE('01-01-2023', 'DD-MM-YYYY') 
	AND dataoraincasari <= TO_DATE('31-12-2023', 'DD-MM-YYYY')	



-- Turism2.10 Extrageți rezervările pentru care, simultan (pe aceeași rezervare) 
-- au fost contractate și sejururi, și circuite 
-- (soluția nu va folosi nici auto-joncțiuni, și nici INTERSECT!) 

SELECT * 
FROM rezervari_sejururi rs
INNER JOIN rezervari r
	ON rs.idrezervare = r.idrezervare
INNER JOIN rezervari_circuite rc
	ON r.idrezervare = rc.idrezervare


-- Turism2.11 Afișați primele trei transporturi din fiecare circuit turistic 

SELECT * 
FROM (
	SELECT nume_circuit_turistic, tiptransport, data_ora_inceput,
		ROW_NUMBER() OVER(
			PARTITION BY ct.idcircuitturistic
			ORDER BY data_ora_inceput
		) AS nr_transport
		
	FROM transporturi t
	INNER JOIN transporturi_circuite tc
		ON t.idtransport = tc.idtransport
	INNER JOIN circuite_turistice ct
		ON tc.idcircuitturistic = ct.idcircuitturistic
)
WHERE nr_transport <= 3



-- Turism2.12 Care sunt circuitele cu mai multe obiective decât circuitul cu numele X? 

SELECT nume_circuit_turistic, COUNT(ot.idobiectiv) AS numar_obiective
FROM circuite_turistice ct
INNER JOIN obiective_turistice_circuite otc
	ON ct.idcircuitturistic = otc.idcircuitturistic
INNER JOIN obiective_turistice ot
	ON otc.idobiectiv = ot.idobiectiv
	
GROUP BY nume_circuit_turistic
HAVING COUNT(otc.idobiectiv) > (

	SELECT COUNT(t.idobiectiv)
	FROM obiective_turistice t
	INNER JOIN obiective_turistice_circuite o
		ON t.idobiectiv = o.idobiectiv
	INNER JOIN circuite_turistice c
		ON o.idcircuitturistic = c.idcircuitturistic
	WHERE nume_circuit_turistic = 'Circuitul X'
)


-- Turism2.13 Care sunt clienții care s-au cazat în (cel puțin) 
-- toate hotelurile în care s-a cazat clientul Ionescu? 

SELECT DISTINCT p.idpersoana, p.numepersoana, p.prenumepersoana
FROM persoane p
WHERE p.numepersoana != 'Ionescu'
	AND NOT EXISTS (
	    SELECT h.idhotel 
	    FROM hoteluri h
	    INNER JOIN camere_hotel ch 
			ON h.idhotel = ch.idhotel
	    INNER JOIN sejururi s 
			ON ch.idcamera = s.idcamera
	    INNER JOIN rezervari_sejururi rs 
			ON s.idsejur = rs.idsejur
	    INNER JOIN rezervari r 
			ON rs.idrezervare = r.idrezervare
	    INNER JOIN persoane p2 
			ON r.codclient = p2.idpersoana
	    WHERE p2.numepersoana = 'Ionescu'
    
    	EXCEPT
    
	    SELECT h3.idhotel
	    FROM hoteluri h3
	    INNER JOIN camere_hotel ch3 
			ON h3.idhotel = ch3.idhotel
	    INNER JOIN sejururi s3 
			ON ch3.idcamera = s3.idcamera
	    INNER JOIN rezervari_sejururi rs3 
			ON s3.idsejur = rs3.idsejur
	    INNER JOIN rezervari r3 
			ON rs3.idrezervare = r3.idrezervare
	    WHERE r3.codclient = p.idpersoana
)


-- Turism2.14 Calculați ponderea clienților din România 
-- în totalul încasărilor hotelurilor din Italia în 2023. 


SELECT
(
SELECT SUM(ir.transa_rezervare)
FROM incasari i 
INNER JOIN incasari_rezervari ir
	ON i.idincasare = ir.idincasare
INNER JOIN rezervari r
	ON ir.idrezervare = r.idrezervare
INNER JOIN persoane p
	ON r.codclient = p.idpersoana
INNER JOIN localitati lp
	ON p.idlocalitatepersoana = lp.idlocalitate
INNER JOIN tari tp
	ON lp.idtara = tp.idtara
INNER JOIN rezervari_sejururi rs
	ON r.idrezervare = rs.idrezervare
INNER JOIN sejururi s
	ON rs.idsejur = s.idsejur
INNER JOIN camere_hotel ch
	ON s.idcamera = ch.idcamera
INNER JOIN hoteluri h
	ON ch.idhotel = h.idhotel
INNER JOIN localitati lh
	ON h.idlocalitate = lh.idlocalitate
INNER JOIN tari th
	ON lh.idtara = th.idtara
WHERE tp.numetara = 'Romania'
	AND th.numetara = 'Italia'
	AND dataoraincasari >= TO_DATE('01-01-2023', 'DD-MM-YYYY') 
	AND dataoraincasari <= TO_DATE('31-12-2023', 'DD-MM-YYYY')
)
/
(
SELECT SUM(ir1.transa_rezervare)
FROM incasari i1 
INNER JOIN incasari_rezervari ir1
	ON i1.idincasare = ir1.idincasare
INNER JOIN rezervari r1
	ON ir1.idrezervare = r1.idrezervare
INNER JOIN rezervari_sejururi rs1
	ON r1.idrezervare = rs1.idrezervare
INNER JOIN sejururi s1
	ON rs1.idsejur = s1.idsejur
INNER JOIN camere_hotel ch1
	ON s1.idcamera = ch1.idcamera
INNER JOIN hoteluri h1
	ON ch1.idhotel = h1.idhotel
INNER JOIN localitati l1
	ON h1.idlocalitate = l1.idlocalitate
INNER JOIN tari t1
	ON l1.idtara = t1.idtara
WHERE t1.numetara = 'Italia'
	AND dataoraincasari >= TO_DATE('01-01-2023', 'DD-MM-YYYY') 
	AND dataoraincasari <= TO_DATE('31-12-2023', 'DD-MM-YYYY')
) * 100 AS ponderea


-- Turism2.15 Pe ce poziție se găsește hotelul X în 
-- topul hotelurilor din Grecia, după numărul de sejururi?

SELECT numehotel, nr_sejururi, pozitie
FROM(
SELECT numehotel, numetara, COUNT(idsejur) AS nr_sejururi, 
	RANK() OVER(ORDER BY COUNT(idsejur) DESC) AS pozitie
FROM sejururi s
INNER JOIN camere_hotel ch
	ON s.idcamera = ch.idcamera
INNER JOIN hoteluri h
	ON ch.idhotel = h.idhotel
INNER JOIN localitati l
	ON h.idlocalitate = l.idlocalitate
INNER JOIN tari t
	ON l.idtara = t.idtara
WHERE numetara = 'Grecia'
GROUP BY numehotel, numetara
)
WHERE numehotel = 'Hotel X'
