package com.tap.util;

import java.sql.Connection;

public class TestDBConnection {

    public static void main(String[] args) {

        try {
            Connection connection = DBConnection.getConnection();

            if (connection != null) {
                System.out.println("Database connection successful!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}