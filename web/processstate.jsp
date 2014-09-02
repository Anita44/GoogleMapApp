<%-- 
    Document   : processsstate
    Created on : 22/08/2014, 09:20:45 PM
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
            loc.setZip("");
            loc.setCity(request.getParameter("city"));
            loc.setState(request.getParameter("state"));
            LocationActions locAct = new LocationActions();
            List<Location> locs = locAct.processLocation(loc);
            loc.setLatitude(locs.get(0).getLatitude());
            loc.setLongitude(locs.get(0).getLongitude());
        %>
    <span id="selectionzippp" >Please select a zip code:</span>
    <select id="selecttonzi" >
        <% int counts = 0;
            for (Location l : locs) {%>
        <option   value="<%=l.getZip()%>"><%=l.getZip()%></option>
        <%counts++;
            }%>
    </select>
    <div id="finaldiv"></div>
    <br>
    <br>
</head>
<body>

</body>
<script type="text/javascript">

    $("#selecttonzi").click(function() {

        $.ajax(
                {
                    type: "POST",
                    url: "processzipcode.jsp",
                    data: "zip=" + $("#selecttonzi").val(),
                    success: function(msg) {
                        $("#finaldiv").html(msg);
                    },
                    error: function(xml, msg) {
                        // $("span#ap").text(" Error");
                    }
                });
    });
    clearAll();
    //console.log("<%=loc%>");
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
                        position: latLong
                    });
                    markers.push(marker);
                    map.setZoom(9);
                } else {
                    console.log("entre aqui");
                    map.setCenter(results[0].geometry.location);
                    var marker = new google.maps.Marker({
                        map: map,
                        position: results[0].geometry.location
                    });
                    markers.push(marker);
                    map.setZoom(9);
                }

            } else {
                alert("Geocode was not successful for the following reason: " + status);
            }
        });

    }
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
            map.setZoom(9);
        } else {
            alert("This location is not registered in our database");
        }
    }
    this.locateFinalAddress();
    function clearAll() {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
    }


</script>
</html>
