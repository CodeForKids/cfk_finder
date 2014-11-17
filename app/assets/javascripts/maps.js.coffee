markers = []
markers_hash = new Object()
map = null
infoWindow = null
zoomLevel = 13

root = exports ? this
root.centerOnMarker = (id) ->
  marker = markers_hash[id]
  map.setCenter(marker.position)
  map.setZoom(zoomLevel-5)
  google.maps.event.trigger( marker, 'click' );

makeContentString = (contentString, marker) ->
  "<div id=\"content\">" +
  "<h1 id=\"firstHeading\" class=\"firstHeading\">#{marker.title}</h1>" +
  "<div id=\"bodyContent\">#{contentString}</div>" +
  "</div>"

createMarker = (myLatLng, title, contentString, id) ->
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
  markers_hash[id] = marker
  marker

createSearchBox = () ->
  searchInput = document.getElementById('pac-input');
  map.controls[google.maps.ControlPosition.TOP_LEFT].push(searchInput);

  searchBox = new google.maps.places.SearchBox(searchInput);
  google.maps.event.addListener searchBox, "places_changed", ->
    places = searchBox.getPlaces()
    return if places.length is 0
    bounds = new google.maps.LatLngBounds()
    jQuery.each places, (->
      bounds.extend this.geometry.location
    )
    map.fitBounds bounds

  google.maps.event.addListener map, "bounds_changed", ->
    bounds = map.getBounds()
    searchBox.setBounds bounds

initialize = ->
  if(document.getElementById('map') != null)
    bounds = new google.maps.LatLngBounds()
    mapOptions =
      zoom: zoomLevel

    infoWindow = new google.maps.InfoWindow({})
    map = new google.maps.Map(document.getElementById("map"), mapOptions)

    user_latlong = new google.maps.LatLng($('#map').data("latitude"), $('#map').data("longitude"))

    jQuery.getJSON("/json_markers.json", (json_markers) ->
      jQuery.each json_markers, (->
        myLatLng = new google.maps.LatLng(this["latitude"], this["longitude"])
        bounds.extend(myLatLng)
        createMarker(myLatLng, this["title"], this["content"], this["id"])
      )
    )

    map.setCenter(user_latlong)
    createSearchBox()

$(document).on('ready page:load', initialize);
