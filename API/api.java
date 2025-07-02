import java.sql.*;

public class api {
    public static void main(String[] args) throws Exception {
        // Database connection details
        String url = "jdbc:postgresql://localhost:5432/project";
        String username = "postgres";
        String password = "ashish";

        // Establish connection to the database
        Connection con = DriverManager.getConnection(url, username, password);

        // First SQL Query
        String sql1 = "SELECT movie_title, price FROM Movie ORDER BY price DESC LIMIT 3;";
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery(sql1);
        System.out.println("Top 3 Movies by Price:");
        while (rs1.next()) {
            System.out.println(rs1.getString("movie_title") + "  " + rs1.getDouble("price"));
        }
        System.out.println();

        // Second SQL Query
        String sql2 = "SELECT s.show_date, s.start_time, s.end_time, c.cinema_name, c.cinema_city "
                + "FROM Showtime s "
                + "INNER JOIN Screen sc ON s.screen_id = sc.screen_id "
                + "INNER JOIN Cinema c ON sc.cinema_name = c.cinema_name AND sc.cinema_pincode = c.cinema_pincode "
                + "WHERE s.movie_title = 'Black Panther' "
                + "AND c.cinema_city = 'Mumbai' "
                + "AND s.is_active = TRUE;";

        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery(sql2);
        System.out.println("Showtimes for 'Black Panther' in Mumbai:");
        while (rs2.next()) {
            System.out.println("Show Date: " + rs2.getDate("show_date")
                    + ", Start Time: " + rs2.getTime("start_time")
                    + ", End Time: " + rs2.getTime("end_time")
                    + ", Cinema: " + rs2.getString("cinema_name")
                    + ", City: " + rs2.getString("cinema_city"));
        }

        // Close resources
        rs1.close();
        rs2.close();
        st1.close();
        st2.close();
        con.close();
    }
}
