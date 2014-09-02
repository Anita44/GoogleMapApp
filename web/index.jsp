<%-- 
    Document   : index
    Created on : 21/08/2014, 10:11:22 AM
    Author     : Luis Fernández <@lfernandez93>
--%>

<%@page import="com.trialperiod.googlemapapp.logic.LocationDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.trialperiod.googlemapapp.logic.Location"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=yes" />
        <title>Google Map App</title>
        <style type="text/css">
            html { height: 100% }
            body { height: 100%; margin: 0; padding: 0 }
            #map_canvas { height: 100% }
        </style>
        <script src="jquery-1.11.1.min.js"></script>
        <script src="jquery.autocomplete.js"></script>
        <script type="text/javascript"
                src="http://maps.googleapis.com/maps/api/js?key=AIzaSyCH8lKmy_g02W347hWpKdNkwIsyp9huNBU&sensor=FALSE">
        </script>
        <script type="text/javascript">
            var map;
            function initialize() {
                var mapOptions = {
                    center: new google.maps.LatLng(39.50, -98.35),
                    zoom: 6,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                };
                map = new google.maps.Map(document.getElementById("map_canvas"),
                        mapOptions);
            }
        </script>
    </head>
    <body style="background-color: aqua;" onload="initialize()">
        <br>
        <br>
        <div id="buttons" style="margin:auto;">
            <center><input type="text" placeholder="00216 Portsmouth, NH " name="address" id="address" style="margin:auto;"/> 
                <button id="go" type="button" style="margin:auto;">Go!</button></center>
        </div>
        <br>
        <br>
    <center><div id="mis" style="margin: auto;"> </div></center>
    <div id="map_canvas" style="width:50%; height:50%; margin-left: auto; margin-right:auto;" ></div>

</body>
<script type="text/javascript">
    var markers = [];
    clearAll();
    var count = 0;
    $("#go").click(function() {
        var address = $("#address").val();
        if (address.length !== 0) {

            $.ajax({
                type: "POST",
                url: "process.jsp",
                data: "address=" + address,
                success: function(msg) {
                    $("#mis").html(msg);
                },
                error: function(xml, msg) {
                    // $("span#ap").text(" Error");
                }
            });
        } else {
            alert("You have entered an empty address");
        }
    });
    function clearAll() {
        for (var i = 0; i < markers.length; i++) {
            markers[i].setMap(null);
        }
    }
</script>

</html>
