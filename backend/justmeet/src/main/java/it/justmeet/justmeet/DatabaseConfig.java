package it.justmeet.justmeet;

import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Value;

public class DatabaseConfig {
    @Value("spring.datasource.url")
    static String dbUrl;

    public static Connection getConnection() throws URISyntaxException, SQLException {
        return DriverManager.getConnection(dbUrl);
    }
}