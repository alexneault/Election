/*
01-create
*/

CREATE TABLE IF NOT EXISTS election(
    election_id INTEGER PRIMARY KEY NOT NULL,
    election_date DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS candidat(
    candidat_id INTEGER PRIMARY KEY NOT NULL,
    candidat_nom VARCHAR(50) NOT NULL,
    candidat_prenom VARCHAR(50) NOT NULL,
    candidat_budget REAL NOT NULL,
    candidat_profession VARCHAR(50) NULL
);

CREATE TABLE IF NOT EXISTS parti(
    parti_id INTEGER PRIMARY KEY NOT NULL,
    parti_nom VARCHAR(50) NOT NULL,
    parti_abv VARCHAR(15) NOT NULL

);

CREATE TABLE IF NOT EXISTS chef(
    chef_id INTEGER PRIMARY KEY NOT NULL,
    candidat_id INTEGER REFERENCES candidat(candidat_id),
    parti_id INTEGER REFERENCES parti(parti_id)
);

CREATE TABLE IF NOT EXISTS compte(
    compte_id INTEGER PRIMARY KEY NOT NULL,
    compte_nom VARCHAR(30) NOT NULL,
    compte_province VARCHAR(30) NOT NULL,
    compte_code_postal VARCHAR(3) ARRAY NOT NULL
);

CREATE TABLE IF NOT EXISTS station(
    station_id INTEGER PRIMARY KEY NOT NULL ,
    station_nom VARCHAR(30) NOT NULL,
    station_nb_elec INTEGER NOT NULL,
    station_ouverture DATE NOT NULL,
    station_fermeture DATE NOT NULL,
    station_date_envoi TIMESTAMP NULL,
    vote_par_anticipation CHAR,
    compte_id INTEGER REFERENCES compte(compte_id)
);

CREATE TABLE IF NOT EXISTS vote(
    candidat_id INTEGER NOT NULL,
    station_id INTEGER NOT NULL,
    vote_nb_vote INTEGER NOT NULL,
    date_envoie DATE,
    CONSTRAINT PK_Vote PRIMARY KEY(
            candidat_id,
            station_id
        ),
        FOREIGN KEY (candidat_id) REFERENCES candidat(candidat_id),
        FOREIGN KEY (station_id) REFERENCES station(station_id)
);
CREATE TABLE IF NOT EXISTS resultat_compte(
     ministre_id INTEGER,
     ministre_compte INTEGER ,
     CONSTRAINT PK_Ministre PRIMARY KEY(
             ministre_id,
             ministre_compte
     ),
     FOREIGN KEY (ministre_id) REFERENCES candidat(candidat_id),
     FOREIGN KEY (ministre_compte) REFERENCES compte(compte_id)
);




ALTER TABLE candidat ADD parti_id INTEGER NOT NULL ;
ALTER TABLE candidat ADD CONSTRAINT fk_parti_id FOREIGN KEY (parti_id) REFERENCES parti(parti_id);
ALTER TABLE candidat ADD compte_id INTEGER NOT NULL;
ALTER TABLE candidat ADD CONSTRAINT fk_compte_id FOREIGN KEY (compte_id) REFERENCES compte(compte_id);
ALTER TABLE parti ADD CHEF_ID INTEGER NULL;
ALTER TABLE parti ADD CONSTRAINT fk_chef_id FOREIGN KEY (chef_id) REFERENCES chef(chef_id);
