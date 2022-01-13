--Question 3
CREATE VIEW budget_partie as
    SELECT parti_nom as nom_partie ,sum(candidat_budget) as total_budget,avg(candidat_budget) as avg_candidat_parti_budget
    FROM candidat INNER JOIN parti ON parti.parti_id=candidat.parti_id
    GROUP BY parti_nom;

--Question 4
CREATE OR REPLACE VIEW station_ouverte as
    SELECT compte_nom ,count(station) as nb_station
    FROM station INNER JOIN compte ON station.compte_id = compte.compte_id
    GROUP BY compte_nom;

--Question 5
CREATE OR REPLACE VIEW probabilite_candidat as
    SELECT parti.parti_id,parti.parti_nom,1.0*count(DISTINCT candidat_id)/count(DISTINCT compte.compte_id) as probabilité
    FROM candidat INNER JOIN parti on parti.parti_id=candidat.parti_id,compte
    WHERE candidat.parti_id=parti.parti_id
    GROUP BY parti.parti_id;


--Question 6
CREATE OR REPLACE VIEW votes_candidats as
    SELECT candidat.parti_id as parti_id,parti.parti_nom as partie_nom,candidat.candidat_nom as candidat_nom,sum(vote_nb_vote) as nb_total_vote
    FROM candidat INNER JOIN parti on candidat.parti_id=parti.parti_id INNER JOIN vote on candidat.candidat_id=vote.candidat_id
    GROUP BY candidat.parti_id,parti.parti_nom,candidat_nom;

--Question 7
CREATE OR REPLACE VIEW info_province as
    SELECT compte_province as province, parti.parti_nom as parti_nom,sum(distinct vote.vote_nb_vote)
    from compte INNER JOIN candidat ON candidat.compte_id=compte.compte_id
        INNER JOIN vote on candidat.candidat_id = vote.candidat_id
        INNER JOIN parti on parti.parti_id=candidat.parti_id
    GROUP BY compte_province, parti.parti_nom;

--Question 8
ALTER TABLE vote
ADD CHECK (vote_nb_vote>0);

--Question 9
ALTER TABLE compte
ADD CONSTRAINT check_format CHECK(compte_code_postal::text SIMILAR TO '{[A-Z][0-9][A-Z]%}');


--Question 10
CREATE PROCEDURE ajout_scrutin(candidat INTEGER,station INTEGER, nb_vote INTEGER)
language plpgsql
AS $$
BEGIN
IF NOT EXISTS(SELECT * FROM vote WHERE station_id=station AND candidat_id=candidat)
    THEN
        INSERT INTO vote VALUES (candidat, station,nb_vote);
    END IF;
END
$$;

--Question 11
CREATE PROCEDURE demarrer_scrutin()
language plpgsql
AS $$
BEGIN
IF EXISTS(SELECT * FROM vote )
    THEN
        DELETE FROM vote where candidat_id =candidat_id;
    END IF;
END
$$;


--Question 12
CREATE OR REPLACE PROCEDURE bulletin_abbrege(in num INTEGER)
language plpgsql
AS $$
BEGIN
    EXECUTE format('CREATE OR REPLACE VIEW bulletin_abrege AS
    SELECT concat(substring(candidat_nom,1,1),substring(candidat_prenom,1,1)) as initiales,parti_abv as abbrevation_parti,compte_nom as compte_nom
    FROM candidat INNER JOIN parti ON candidat.parti_id=parti.parti_id INNER JOIN compte ON candidat.compte_id=compte.compte_id
    WHERE candidat.compte_id = %L', num);
END;
$$;

call bulletin_abbrege(3);

--Question 13
CREATE INDEX nom_compte
ON compte(compte_nom);

CREATE INDEX nom_candidat
ON candidat(candidat_nom,candidat_prenom);
