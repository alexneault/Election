/*TRIGGER-03*/

--Question 14
CREATE OR REPLACE FUNCTION station_verif() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    DECLARE
        date_election DATE;
    BEGIN
        SELECT election_date INTO date_election FROM election
        WHERE election_id=1;
        IF NEW.station_ouverture<>date_election THEN
            IF NEW.vote_par_anticipation ='N' THEN
                RAISE EXCEPTION '% La date de l''election est invalide', NEW.station_nom;
            end if;
        end if;
        return NEW;
    END
    $$;

CREATE TRIGGER verif_date_station BEFORE INSERT OR UPDATE ON station
    FOR EACH ROW EXECUTE PROCEDURE station_verif();


--Question 15
CREATE OR REPLACE FUNCTION budget_verif() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    DECLARE
        total INT;
    BEGIN
        SELECT sum(candidat_budget) INTO total FROM candidat INNER JOIN parti ON parti.parti_id=candidat.parti_id
            WHERE candidat.parti_id=parti.parti_id;
        IF total>10000000 THEN
            RAISE EXCEPTION '% le budget est plus grand que 10 000 000 pour ce parti.',NEW.parti_id;
        end if;
        return NEW;
    END
    $$;


CREATE TRIGGER verif_budget AFTER INSERT OR UPDATE ON candidat
    FOR EACH ROW EXECUTE PROCEDURE budget_verif();


--Question 16
CREATE OR REPLACE FUNCTION parti_compte_verif() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    DECLARE
         nb_pareil INT;
    BEGIN
        SELECT count(candidat_id) INTO nb_pareil FROM candidat INNER JOIN compte ON compte.compte_id=candidat.compte_id
        INNER JOIN parti ON parti.parti_id=candidat.parti_id
        WHERE NEW.parti_id=parti.parti_id AND NEW.compte_id=compte.compte_id;
        IF nb_pareil>1 THEN
            RAISE EXCEPTION '%: Il y a déjà un candidat de ce parti dans le compté',NEW.candidat_nom;
        end if;
    return NEW;
    END
    $$;

CREATE TRIGGER parti_compte_verification AFTER INSERT OR UPDATE ON candidat
    FOR EACH ROW EXECUTE PROCEDURE parti_compte_verif();


--Question 17
CREATE OR REPLACE FUNCTION debut_fin_verif() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
    DECLARE
    BEGIN
        IF NEW.station_ouverture > NEW.station_fermeture THEN
             RAISE EXCEPTION 'La date d''ouverture doit etre avant celle de fermeture';
        end if;
    RETURN NEW;
    END
    $$;

CREATE TRIGGER date_debut_fin BEFORE INSERT OR UPDATE ON station
    FOR EACH ROW EXECUTE PROCEDURE debut_fin_verif();



--Question 18
create or replace function envoi_resultat() returns trigger
    language plpgsql
as
$$
DECLARE
        station_verif INT;
        compte_verif INT;
        max_station_candidat INT;
    BEGIN
        station_verif=NEW.station_id;
        SELECT compte_id into compte_verif from vote INNER JOIN station on vote.station_id = station.station_id
        WHERE station.station_id=station_verif;

        SELECT count(DISTINCT candidat.candidat_id)*count(DISTINCT station.station_id) INTO max_station_candidat
        FROM candidat INNER JOIN station ON candidat.compte_id=station.compte_id
        WHERE candidat.compte_id=compte_verif;

        IF max_station_candidat = (SELECT count(vote.candidat_id)
            FROM vote INNER JOIN station on vote.station_id=station.station_id
            WHERE station.compte_id=compte_verif) THEN
                CREATE TEMP TABLE IF NOT EXISTS total_vote AS
                    SELECT vote.candidat_id, sum(vote_nb_vote) as vote_nb FROM vote INNER JOIN candidat
                    ON vote.candidat_id = candidat.candidat_id
                    WHERE candidat.compte_id=compte_verif
                    group by vote.candidat_id;

                INSERT INTO resultat_compte(ministre_id, ministre_compte)
                SELECT total_vote.candidat_id,candidat.compte_id FROM total_vote
                INNER JOIN candidat ON total_vote.candidat_id=candidat.candidat_id
                WHERE vote_nb=(SELECT max(vote_nb) from total_vote)
                ON CONFLICT (ministre_id,ministre_compte) DO NOTHING;
                DROP TABLE if exists total_vote;
        end if;
    RETURN NEW;
    END
$$;

CREATE TRIGGER ministre_resultat AFTER INSERT OR UPDATE ON vote
    FOR EACH ROW EXECUTE PROCEDURE envoi_resultat();

