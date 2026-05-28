# Sistem-de-Gestiune-i-Analiz-SQL-pentru-Agen-ii-de-Turism
Acest repository conține proiectarea, popularea și interogarea unei baze de date relaționale complexe (`TURISM2`)

Proiectul este structurat sub formă de teme practice care rezolvă scenarii reale de business, utilizând concepte avansate de SQL.

---

## 🗺️ Structura Bazei de Date (Schema)
Baza de date este formată dintr-o arhitectură complexă ce include tabele interconectate pentru:
* **Resurse Umane & Clienți:** `angajati`, `clienti`, `persoane`, `localitati`.
* **Operațiuni & Vânzări:** `rezervari`, `persoane_contact`.
* **Oferte Turistice:** `sejururi`, `circuite`, `hoteluri`, `obiective_turistice`, `transporturi`.
* **Parteneri:** `parteneri` (agenții și furnizori externi).

---

## 📊 Analize și Interogări Rezolvate (Business Intelligence)

Proiectul este împărțit în două secțiuni majore de interogări (DQL), rezolvând următoarele cerințe specifice:

### 🔹 Tema 1: Interogări și Filtrări de Bază
* **Turism2.1 & 2.2:** Analiza disponibilității sejururilor în anul 2024 și filtrarea rezervărilor active pentru luna august 2024.
* **Turism2.3:** Extragerea partenerilor comerciali localizați în Italia.
* **Turism2.4:** Identificarea personalului intern (angajați) care nu au calitatea de clienți ai agenției.

### 🔹 Tema 2: Analize Aprofundate, Agregări și Subinterogări Complexe
* **Analiză Geografică & Volume (2.5 & 2.6):** Centralizarea numărului de sejururi din august 2024 efectuate de clienți români, grupate pe localitățile de proveniență ale acestora.
* **Rapoarte Financiare Pivotate (2.7):** Afișarea încasărilor generate de fiecare angajat (ca persoană de contact), structurate pe coloane separate pentru anii 2018, 2019 și 2020.
* **Performanța Angajaților (2.8):** Identificarea angajaților riguroși care nu au acordat niciun discount până în prezent.
* **Subtotale și Rapoarte Ierarhice (2.9):** Calculul încasărilor pe clienți pentru anul 2023, cu generare de subtotaluri la nivel de lună și total general (`ROLLUP` / `CUBE`).
* **Intersecții Complexe (2.10):** Extragerea rezervărilor care conțin simultan și sejururi și circuite, utilizând tehnici optimizate (fără auto-joncțiuni sau `INTERSECT`).
* **Ierarhii și Topuri (2.11 - 2.15):** 
  * Afișarea primelor 3 transporturi pentru fiecare circuit în parte (folosind funcții analitice/fereastră).
  * Analiza comparativă a circuitelor în funcție de numărul de obiective turistice vizitate.
  * Determinarea clienților fideli prin tehnici de diviziune relațională (clienți cazați în cel puțin toate hotelurile în care s-a cazat un client X).
  * Calculul ponderii financiare a clienților dintr-o regiune în totalul încasărilor externe (Italia).
  * Calcularea poziției exacte (Ranking) a unui hotel în topul popularității din Grecia.

---

## 🛠️ Structura Fișierelor

* `CREARE BAZE DATE.sql` – Scriptul DDL pentru crearea tabelelor, constrângerilor de chei primare/externe și integritate referențială.
* `INSERARE DATE.sql` – Scriptul DML pentru inserarea datelor de test (clienți, hoteluri, rezervări din perioada 2018-2024).
* `Interogari Tema BAze` – Rezolvarea interogărilor 

---

## 💻 Tehnologii și Concepte SQL Aplicate
* **Dialect:** [ PostgreSQL ]
* **Concepte:** `LEFT/RIGHT/INNER JOIN`, Funcții Agregate (`SUM`, `COUNT`), `GROUP BY` cu `ROLLUP`, Funcții Fereastră / Analitice (`ROW_NUMBER()`, `RANK()`), Subinterogări corelate, Diviziune Relațională.
