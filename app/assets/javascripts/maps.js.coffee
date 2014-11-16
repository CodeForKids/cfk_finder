$(document).on "ready page:load", ->
  if(document.getElementById('map') != null)
    markers = []
    map = null
    infoWindow = null

    makeContentString = (contentString, marker) ->
      "<div id=\"content\">" +
      "<h1 id=\"firstHeading\" class=\"firstHeading\">#{marker.title}</h1>" +
      "<div id=\"bodyContent\">#{contentString}</div>" +
      "</div>"

    createMarker = (myLatLng, title, contentString, i) ->
      marker = new google.maps.Marker(
        position: myLatLng
        map: map
        title: title
      )
      google.maps.event.addListener marker, "click", ->
        html_string = makeContentString(contentString, marker)
        infoWindow.setContent html_string
        infoWindow.open map, marker

      markers.push(marker)
      marker

    initialize = ->
      bounds = new google.maps.LatLngBounds()
      mapOptions =
        zoom: 4

      infoWindow = new google.maps.InfoWindow({})
      map = new google.maps.Map(document.getElementById("map"), mapOptions)

      jQuery.each $('#map').data('markers'), (->
        myLatLng = new google.maps.LatLng(this["latitude"], this["longitude"])
        bounds.extend(myLatLng)
        createMarker(myLatLng, this["title"], this["content"])
      )

      map.fitBounds(bounds)

    google.maps.event.addDomListener window, "load", initialize
