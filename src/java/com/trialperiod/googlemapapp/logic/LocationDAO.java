/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.trialperiod.googlemapapp.logic;

import java.util.List;

/**
 *
 * @author Luis Fernández <@lfernandez93>
 */
public class LocationDAO implements DAO<Location> {

    DBManager<Location> dbManager;

    public LocationDAO() {
        dbManager = DBManager.getInstance();
    }

    @Override
    public boolean insert(Location object) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Location get(Location object) {
        StringBuilder query = new StringBuilder("SELECT * FROM  locations  WHERE zip='");
        query.append(object.getZip()).append("'");
        List<Location> temp = dbManager.query(query.toString(), Location.class);
        if (!temp.isEmpty()) {
            object = temp.get(0);
        }
        return object;
    }
    /**
     * the server will die with this query
     * @return 
     */
    @Override
    public List<Location> getAll() {
        List<Location> locations = dbManager.query("SELECT TOP 200 * FROM locations", Location.class);
        return locations;
    }

    @Override
    public boolean delete(Location object) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean update(Location object) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    public List<Location> getAllByState(String parameter) {
        List<Location> locations = dbManager.query("SELECT DISTINCT city FROM locations WHERE state='" + parameter + "'", Location.class);
        return locations;
    }

    public List<Location> getStateByCity(String parameter) {
        List<Location> locations = dbManager.query("SELECT  state FROM locations WHERE city ='" + parameter + "' GROUP BY locations.state", Location.class);
        return locations;
    }

    public List<Location> getAllByCity(String parameter) {
        System.err.println("SELECT  * FROM locations WHERE city ='" + parameter + "'");
        List<Location> locations = dbManager.query("SELECT  * FROM locations WHERE city ='" + parameter + "'", Location.class);

        return locations;
    }

    public List<Location> getAllByCityAndState(String parameter) {
        String[] parameters = parameter.split(";");
        List<Location> locations = dbManager.query("SELECT * FROM locations WHERE city ='" + parameters[0] + "' AND state ='" + parameters[1] + "'", Location.class);
        return locations;
    }
}
