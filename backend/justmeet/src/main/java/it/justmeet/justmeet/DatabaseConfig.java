package it.justmeet.justmeet;

import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {
    public static Connection getConnection() throws URISyntaxException, SQLException {
        String dbUrl = "jdbc:postgresql://ec2-46-137-120-243.eu-west-1.compute.amazonaws.com:5432/dctq26iqsf16r7?user=kgapespdyqobhl&password=bb765ee804bc0e6d6241e0f5f955e73376a8442426aa1a8b402ec6ad41bcb3d2&sslmode=require";
        return DriverManager.getConnection(dbUrl);
    }
}