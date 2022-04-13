-- TABLE
CREATE TABLE "Compartment" (id integer PRIMARY KEY AUTOINCREMENT not NULL, hour text, repetition integer, start_date text, end_date text, name text);
CREATE TABLE "Compartment_days" (alarm_id integer not NULL, days_id integer not NULL);
CREATE TABLE days (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, name text);
CREATE TABLE sqlite_sequence(name,seq);
 
-- INDEX
 
-- TRIGGER
 
-- VIEW
 
