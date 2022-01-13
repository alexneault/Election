/**
 * Alex Neault - NEAA02089809
 * Mohamed Zaafir Adeoti – ADEM19089800
 * Ikbal Akinotcho – AKII83030201
 * Question 19
 * Doit avoir les drivers de postgres dans le projet
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.*;

public class Main {

    public static void main(String[] args) {
        final String url = "jdbc:postgresql://localhost:5432/postgres";
        final String user = "postgres";
        final String password = "admin";
        Statement stmt = null;
        Connection conn = null;
        Scanner sc = new Scanner(System.in);
        boolean test_row = true;
        try {
            Class.forName("org.postgresql.Driver");
            conn = DriverManager.getConnection(url, user, password);
            System.out.println("Connected to the PostgreSQL server successfully.");
            int id_station = 0;
            int id_compte = 0;
            int candidat_vote = 0;
            String finaliser = "";
            stmt = conn.createStatement();
            String station_fermeture="";

            System.out.println("Application de comptabilisation des votes de l'élection.\n");

            while(test_row==true) {
                System.out.println("Veuillez entrer le numéro de la station: ");
                id_station = sc.nextInt();
                ResultSet rs = stmt.executeQuery("SELECT * FROM station WHERE station_id=" + id_station + ";");
                if (rs.next() == true) {
                    test_row = false;
                }
                else{
                    System.out.println("cette station n'existe pas");
                }
            }

            ResultSet rs = stmt.executeQuery("SELECT * FROM station WHERE station_id=" + id_station + ";");
            rs.next();
            id_compte=Integer.parseInt(rs.getString("compte_id"));
            rs=stmt.executeQuery("SELECT * FROM candidat WHERE compte_id="+id_compte+";");

            while (rs.next()){
                System.out.println(rs.getString("candidat_nom")+", "+rs.getString("candidat_prenom"));
            }

            ResultSet station = stmt.executeQuery("SELECT * FROM station WHERE station_id=" + id_station + ";");
            station.next();
            station_fermeture = station.getString("station_fermeture");
            ResultSet candidat=stmt.executeQuery("SELECT * FROM candidat WHERE compte_id="+id_compte+";");


            while(candidat.next()){
                System.out.println("\nNombre de vote pour "+candidat.getString("candidat_nom")+", "+candidat.getString("candidat_prenom")+" à cette station: ");
                candidat_vote=sc.nextInt();
                Statement exec=conn.createStatement();
                exec.executeUpdate("INSERT INTO vote (candidat_id, station_id, vote_nb_vote,date_envoie)"
                        +"VALUES ("+candidat.getString("candidat_id")+","+id_station+","+candidat_vote+",'"+station_fermeture+"')");
            }
            test_row=true;
            while(test_row==true){
                System.out.println("Est-ce que cette station est prête à finaliser les votes?(oui ou non): ");
                sc.nextLine();
                finaliser=sc.nextLine();

                if(finaliser.equals("oui")||finaliser.equals("non")){
                    if(finaliser.equals("oui")){
                        Statement exec=conn.createStatement();
                        exec.executeUpdate("UPDATE station SET station_date_envoi='"+station_fermeture+" 17:30:00' WHERE station_id="+id_station+";");
                        test_row=false;
                    }
                    else{
                        test_row=false;
                    }
                }
                else{
                    System.out.println("Réponse invalide!");
                }
            }
            System.out.println("Programme terminé");

            conn.close();
        } catch (SQLException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
    }
}
