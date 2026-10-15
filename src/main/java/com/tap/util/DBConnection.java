package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    private static String getEnv(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.isBlank()) ? defaultValue : value.trim();
    }

    public static String getUrl() {
        // 1. Explicit DB_URL or Railway MYSQL_URL
        String rawUrl = getEnv("DB_URL", getEnv("MYSQL_URL", null));
        if (rawUrl != null) {
            if (rawUrl.startsWith("mysql://")) {
                rawUrl = "jdbc:" + rawUrl;
            }
            if (!rawUrl.contains("allowPublicKeyRetrieval")) {
                String separator = rawUrl.contains("?") ? "&" : "?";
                rawUrl = rawUrl + separator + "allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
            }
            return rawUrl;
        }

        // 2. Construct from host, port, db name
        String host = getEnv("DB_HOST", getEnv("MYSQLHOST", "localhost"));
        String port = getEnv("DB_PORT", getEnv("MYSQLPORT", "3306"));
        String dbName = getEnv("DB_NAME", getEnv("MYSQLDATABASE", "foodwala"));

        return "jdbc:mysql://" + host + ":" + port + "/" + dbName
                + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    }

    public static String getUsername() {
        return getEnv("DB_USERNAME", getEnv("MYSQLUSER", "root"));
    }

    public static String getPassword() {
        return getEnv("DB_PASSWORD", getEnv("MYSQLPASSWORD", ""));
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(getUrl(), getUsername(), getPassword());
    }
}

