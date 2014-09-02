/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.trialperiod.googlemapapp.logic;

/**
 *
 * @author Luis Fernández <@lfernandez93>
 */
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBManager<T> {

    private String dbName = ";databaseName=locations";
    private String id = "sa";
    private String pw = "123456";
    private String address = "jdbc:sqlserver://ec2-54-234-134-233.compute-1.amazonaws.com:1433";
    private String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private Statement st;
    private Connection con;
    private static DBManager dbManager;

    private DBManager() {
        stablishConnection();
    }

    public static DBManager getInstance() {
        if (dbManager != null) {
            return dbManager;
        }
        return dbManager = new DBManager();
    }

    public Connection stablishConnection() {
        try {
            Class.forName(driver);
            con = DriverManager.getConnection(address + dbName, id, pw);

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("error connecting to database");
        }
        return con;
    }

    public List<T> query(String command, Class c) {
        List<T> list = new ArrayList<>();

        ResultSet rs = null;
        Object obj = null;
        try {

            st = con.createStatement();
            rs = st.executeQuery(command);
            while (rs.next()) {
                try {
                    obj = Class.forName(c.getName()).newInstance();
                } catch (ClassNotFoundException | InstantiationException | IllegalAccessException ex) {
                    Logger.getLogger(DBManager.class.getName()).log(Level.SEVERE, null, ex);
                }
                Field[] fields = obj.getClass().getDeclaredFields();
                for (Field field : fields) {
                    field.setAccessible(true);
                    try {
                        field.set(obj, rs.getString(field.getName()));
                    } catch (Exception exp) {
                        continue;
                    }
                }

                list.add((T) obj);
            }
        } catch (SQLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        } catch (IllegalArgumentException ex) {
            Logger.getLogger(DBManager.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean insert(String command) {
        try {
            st = con.createStatement();
            st.execute(command);
        } catch (SQLException e) {
            // TODO: handle exception}
            System.out.println(command);
            //e.printStackTrace();
            return false;
        }
        return true;
    }
}
