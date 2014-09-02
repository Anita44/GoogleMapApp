<%-- 
    Document   : process
    Created on : 21/08/2014, 04:00:55 PM
    Author     : Luis Fernández <@lfernandez93>
--%>

<%@page import="com.trialperiod.googlemapapp.logic.DBManager"%>
<%@page import="com.trialperiod.googlemapapp.logic.LocationActions.locType"%>
<%@page import="java.util.List"%>
<%@page import="com.trialperiod.googlemapapp.logic.LocationDAO"%>
<%@page import="com.trialperiod.googlemapapp.logic.LocationActions"%>
<%@page import="com.trialperiod.googlemapapp.logic.Location"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Google Map App</title>
    </head>
    <body>
        <%  boolean locateAdd = false;
            boolean doubleCity = false;
            boolean locateState = false;
            boolean locateCity = false;
            Location loc = new Location();
            String unformatedAddress = request.getParameter("address");
            LocationActions locAct = new LocationActions();
            loc = locAct.generateLocation(unformatedAddress);
            List<Location> locs = locAct.processLocation(loc);
            locType locationsType = locAct.getLocationsTypes();

            switch (locationsType.getLoc()) {
                case ZIP:
                    loc = locs.get(0);
                    locateAdd = true;
                    break;
                case CITY:
                    if (locs.size() > 1) {
                        doubleCity = true;
                        break;
                    } else {

                        loc = new LocationDAO().getAllByCity(loc.getCity()).get(0);
                        locs = new LocationDAO().getAllByCityAndState(loc.getCity() + ";" + loc.getState());
                        System.err.println(loc);
                    }
                case CITYSTATE:
                    locateCity = true;
        %>
        <span id="selectzipp" >Please select a zip code:</span>
        <select id="selectzip">
            <% int counts = 0;
                for (Location l : locs) {%>
            <option   value="<%=l.getLatitude() + ";" + l.getLongitude()%>"><%=l.getZip()%></option>
            <%counts++;
                }%>
        </select>      
        <br>
        <br>
        <%
                break;

            case STATE:
                locateState = true;
        %>

        <div style="margin: auto;">
            <span id="selectParragraph">Please select a city:</span>
            <select id="elselect"  style="margin: auto;">
                <% int count = 0;
                    for (Location l : locs) {%>
                <option   value="<%=l.getCity()%>"><%=l.getCity()%></option>
                <%count++;
                    }%>
            </select>
            <br>
            <br>

        </div>
        <br>
        <br>
        <div id="retrieved"></div>
        <%  loc.setLatitude(locs.get(0).getLatitude());
                    loc.setLongitude(locs.get(0).getLongitude());
                    break;
            }
        %>
    </body>
    <script type="text/javascript">
        clearAll();
        $("#selectzip").click(function() {
            clearAll();
            //$("#retrieved").remove();
            var coords = $("#selectzip").val();
            var coordV = coords.split(";");
            if (coordV !== "null") {
                map.setCenter(new google.maps.LatLng(coordV[0], coordV[1]));
                var marker = new google.maps.Marker({
                    map: map,
                    position: new google.maps.LatLng(coordV[0], coordV[1])
                });
                markers.push(marker);
                map.setZoom(10);
            } else {
                alert("This location is not registered in our database");
            }
        });

        $("#elselect").click(function() {
            var city = $("#elselect").val();
            var state = "<%=loc.getState()%>";
            $.ajax(
                    {
                        type: "POST",
                        url: "processstate.jsp",
                        data: "city=" + city + "&state=" + state,
                        success: function(msg) {
                            $("#retrieved").html(msg);
                        },
                        error: function(xml, msg) {
                            // $("span#ap").text(" Error");
                        }
                    });
        });

        function locateFinalAddress() {
            var lat = "<%=loc.getLatitude()%>";
            var long = "<%=loc.getLongitude()%>";
            var state = "<%=loc.getState()%>";
            var city = "<%=loc.getCity()%>";
            if (lat !== "null") {
                map.setCenter(new google.maps.LatLng(lat, long));
                var marker = new google.maps.Marker({
                    map: map,
                    position: new google.maps.LatLng(lat, long)
                });
                markers.push(marker);
                map.setZoom(10);
            } else {
                alert("This location is not registered in our database");
            }
        }
        function locateParcialAddress() {

            count = 0;
            var state = "<%=loc.getState()%>";
            var city = "<%=loc.getCity()%>";
            var lat = "<%=loc.getLatitude()%>";
            var long = "<%=loc.getLongitude()%>";
            var latLong = new google.maps.LatLng(lat, long);
            var geocoder = new google.maps.Geocoder();

            var address = state + city;
            address = address.replace("null", "");
            geocoder.geocode({'address': address, 'latLng': latLong}, function(results, status) {
                if (status === google.maps.GeocoderStatus.OK) {
                    if (!isNaN(latLong)) {
                        map.setCenter(latLong);
                        var marker = new google.maps.Marker({
                            map: map,
                            position: latLong,
                        });
                        markers.push(marker);

                    } else {
                        map.setCenter(results[0].geometry.location);
                        var marker = new google.maps.Marker({
                            map: map,
                            position: results[0].geometry.location,
                        });
                        markers.push(marker);
                    }
                    map.setZoom(9);
                } else {
                    alert("Geocode was not successful for the following reason: " + status);
                }
            });

        }

        function clearAll() {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(null);
            }
        }

        <% if (locateAdd) {
                out.println("locateFinalAddress();");
            }
            if (locateState || locateCity) {
                out.println("locateParcialAddress();");
            }
            if (doubleCity) {
                out.println("alert('Please specify a State');");
            }
        %>
        //map.setZoom(10);
    </script>
</html>
