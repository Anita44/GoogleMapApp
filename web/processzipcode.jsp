<%-- 
    Document   : processzipcode
    Created on : 22/08/2014, 09:20:19 PM
    Author     : Luis Fernández <@lfernandez93>
--%>

<%@page import="java.util.List"%>
<%@page import="com.trialperiod.googlemapapp.logic.LocationActions"%>
<%@page import="com.trialperiod.googlemapapp.logic.Location"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            Location loc = new Location();
            loc.setZip(request.getParameter("zip"));

            loc.setCity("");
            loc.setState("");
            LocationActions locAct = new LocationActions();
            List<Location> locs = locAct.processLocation(loc);
            loc.setLatitude(locs.get(0).getLatitude());
            loc.setLongitude(locs.get(0).getLongitude());
            System.err.println(loc);
        %>
    </head>
    <body>
    </body>
    <script type="text/javascript">
        console.log("hi");
        clearAll();
        function locateFinalAddress() {
            var lat = "<%=loc.getLatitude()%>";
            var long = "<%=loc.getLongitude()%>";
            var state = "<%=loc.getState()%>";
            var city = "<%=loc.getCity()%>";
            console.log("pasando");
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
        locateFinalAddress();
        function clearAll() {
            for (var i = 0; i < markers.length; i++) {
                markers[i].setMap(null);
            }
        }

    </script>
</html>
