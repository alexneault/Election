--Question 1 et 2

/* Delete scripts*/
DELETE FROM resultat_compte;
DELETE FROM chef;
DELETE FROM vote;
DELETE FROM candidat;
DELETE FROM station;
DELETE FROM compte;
DELETE FROM parti;
DELETE FROM election;



/* 02-insert */

INSERT INTO election(election_id, election_date)
VALUES (1,'2021-08-02');

INSERT INTO parti (parti_id, parti_nom, parti_abv)
VALUES  (1,'Parti Quebecois','PQ'),
        (2,'Partie Liberal','PL'),
        (3, 'Nouveau parti democrates', 'NPD'),
        (4,'Bloc Quebecois','BQ');

INSERT INTO compte(compte_id, compte_nom,compte_province, compte_code_postal)
VALUES  (1,'Mauricie','Quebec','{"G8Y","G8T","G0X","G8V","G8Z"}'),
        (2,'Longueuil','Quebec','{"G8J","J3Y","J4G","J4H","J4K"}'),
        (3,'Laval','Quebec','{"H7N","H7R","H7S","H7Z","H7Q"}'),
        (4,'St-Jerome','Quebec','{"J0R","J5J","J5K","J5H","J5L"}'),
        (5,'Brossard','Quebec','{"J4Y","J4W","J4Z","J4X","J4M"}');

INSERT INTO station(station_id, station_nom, station_nb_elec, station_ouverture, station_fermeture, station_date_envoi,vote_par_anticipation, compte_id)
VALUES  (1,'Arrondissement laval',300,'2021-08-02','2021-08-02','2021-08-02 17:30:00','N',3),
        (2,'Arrondissement Brossard',1000,'2021-08-02','2021-08-02','2021-08-02 17:30:00','N',5),
        (3,'Arrondissement Longueuil',1500,'2021-08-02','2021-08-02','2021-08-02 17:30:00','N',2),
        (4,'Arrondissement Mauricie',200,'2021-07-23','2021-07-30','2021-07-30 17:30:00','Y',1),
        (5,'Arrondissement St-Jerome',200,'2021-07-23','2021-07-30','2021-07-30 17:30:00','Y',4);




INSERT INTO candidat (candidat_id, candidat_nom, candidat_prenom, candidat_budget, candidat_profession, parti_id, compte_id)
VALUES  (1, 'Henri', 'Arthur', 300123, 'Physicien', 1,1),
        (2, 'Therrien', 'Vincent', 300412, 'Artiste', 1,2),
        (3, 'Martin', 'Thierry', 200123, 'Camionneur', 2,1),
        (4, 'Forget', 'Florence', 290123, 'Caissier', 1,4),
        (5, 'Verna', 'Paul', 99000, 'Agent Correctionnel', 1,5),
        (6, 'Fortin', 'Martin', 123413, 'Menuisier', 3,1),
        (7, 'Adeoti', 'Zaafir', 85000, 'Programmeur', 3,2),
        (8, 'Neault', 'Alex', 123434, 'Psychologue', 2,3),
        (9, 'Henris', 'Jordan', 400213, 'Musicien', 4,4),
        (10, 'Cloutier', 'Charles',343254, 'Avocat', 2,4);

INSERT INTO vote (candidat_id, station_id, vote_nb_vote,date_envoie)
VALUES  (1,4,5,'2021-08-02'),
        (6,4,10,'2021-08-02'),
        (3,4,20,'2021-08-02'),
        (5,2,20,'2021-08-02'),
        (9,5,100,'2021-08-02'),
        (7,3,200,'2021-08-02'),
        (4,5,200,'2021-08-02'),
        (10,5,300,'2021-08-02');



INSERT INTO chef(chef_id, candidat_id, parti_id)
VALUES  (1,2,1),
        (2,6,2),
        (3,7,3),
        (4,9,4);
		
UPDATE parti
SET chef_id =1 WHERE parti_id=1;

UPDATE parti
SET chef_id =2 WHERE parti_id=2;

UPDATE parti
SET chef_id =3 WHERE parti_id=3;

UPDATE parti
SET chef_id =4 WHERE parti_id=4;		
		