/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.trialperiod.googlemapapp.logic;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Luis Fernández <@lfernandez93>
 */
public class LocationActions {

    private locType locationsTypes;

    public Location generateLocation(String address) {
        boolean auxDigit = false;
        StringBuilder zip = new StringBuilder();
        StringBuilder city = new StringBuilder();
        StringBuilder state = new StringBuilder();
        for (int i = 0; i < address.length(); i++) {
            char c = address.charAt(i);
            if (Character.isDigit(c) && i != address.length() && auxDigit == false) {
                zip.append(c);
            } else {
                if (i != address.length()) {
                    auxDigit = true;
                    if (address.length() == 2) {
                        state.append(address);
                        break;
                    } else {
                        if (address.length() - i <= 2) {
                            if (Character.isUpperCase(c)) {
                                state.append(c);
                            } else {
                                city.append(c);
                            }
                        } else {
                            city.append(c);
                        }
                    }
                }
            }

        }
        Location loc = new Location();
        loc.setZip(zip.toString());
        loc.setCity(city.toString());
        if (loc.getCity().startsWith(" ") || loc.getCity().contains(",")) {
            if (loc.getCity().startsWith(" ")) {
                loc.setCity(loc.getCity().replaceFirst(" ", ""));
            } else {
                loc.setCity(loc.getCity().replace(",", ""));
            }
        }
        if (loc.getCity().endsWith(" ")) {
            loc.setCity(loc.getCity().substring(0, loc.getCity().length() - 1));
        }
        loc.setState(state.toString());
        if (loc.getState().startsWith(" ") || loc.getState().contains(",")) {
            loc.setState(loc.getState().replaceFirst(" ", "").replace(",", ""));
        }
        if (loc.getState().endsWith(" ")) {
            loc.setState(loc.getState().substring(0, loc.getState().length() - 1));
        }
        return loc;
    }

    public List<Location> getBy(locType e, String parameter) {
        LocationDAO locDAO = new LocationDAO();
        List<Location> locations = new ArrayList<>();
        switch (e) {
            case ZIP:
                Location loc = new Location();
                loc.setZip(parameter);
                loc = new LocationDAO().get(loc);
                locations.add(loc);
                break;
            case STATE:
                locations = locDAO.getAllByState(parameter);
                break;
            case CITY:
                locations = locDAO.getStateByCity(parameter);
                break;
            case CITYSTATE:
                locations = locDAO.getAllByCityAndState(parameter);
                break;

        }
        return locations;
    }

    public List<Location> processLocation(Location loc) {
        locationsTypes = locType.ZERO;
        System.err.println(loc);
        if (loc.getZip().length() != 0) {
            locationsTypes.setLoc(locType.ZIP);
            return getBy(locType.ZIP, loc.getZip());
        } else {
            if (loc.getCity().length() != 0) {
                if (loc.getState().length() != 0) {
                    locationsTypes.setLoc(locType.CITYSTATE);
                    return getBy(locType.CITYSTATE, loc.getCity() + ";" + loc.getState());
                } else {
                    locationsTypes.setLoc(locType.CITY);
                    return getBy(locType.CITY, loc.getCity());
                }
            } else {
                if (loc.getState().length() != 0) {
                    locationsTypes.setLoc(locType.STATE);
                    return getBy(locType.STATE, loc.getState());
                }
            }
        }
        return null;
    }

    public enum locType {

        ZERO, ZIP, STATE, CITY, CITYSTATE;
        private locType loc;

        public locType getLoc() {
            return loc;
        }

        public void setLoc(locType loc) {
            this.loc = loc;
        }

    }

    public locType getLocationsTypes() {
        return locationsTypes;
    }

}
