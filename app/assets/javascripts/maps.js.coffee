markers = []
markers_hash = new Object()
map = null
infoWindow = null
zoomLevel = 13

root = exports ? this
root.centerOnMarker = (id) ->
  marker = markers_hash[id]
  map.panTo(marker.position)
  map.setZoom(zoomLevel-5)
  google.maps.event.trigger( marker, 'click' );

makeContentString = (contentString, url, marker) ->
  "<div id=\"content\">" +
  "<h1 id=\"firstHeading\" class=\"firstHeading\">#{marker.title}</h1>" +
  "<div id=\"bodyContent\">#{contentString}" +
  "<p><a href=\"#{url}\" class=\"btn btn-primary\">Register Now</a></p>" +
  "</div></div>"

createMarker = (myLatLng, title, url, contentString, id) ->
  marker = new google.maps.Marker(
    position: myLatLng
    map: map
    title: title
  )
  google.maps.event.addListener marker, "click", ->
    html_string = makeContentString(contentString, url, marker)
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
    map.setZoom(zoomLevel)

  google.maps.event.addListener map, "bounds_changed", ->
    bounds = map.getBounds()
    searchBox.setBounds bounds

initialize = ->
  if(document.getElementById('map') != null)
    bounds = new google.maps.LatLngBounds()
    user_latlong = new google.maps.LatLng($('#map').data("latitude"), $('#map').data("longitude"))

    mapOptions =
      zoom: zoomLevel,
      center: user_latlong

    infoWindow = new google.maps.InfoWindow({})
    map = new google.maps.Map(document.getElementById("map"), mapOptions)

    $('.event-data').each ->
      myLatLng = new google.maps.LatLng($(this).data('latitude'), $(this).data('longitude'))
      bounds.extend(myLatLng)
      createMarker(myLatLng, "#{$(this).data('name')} (#{$(this).data('price')})", $(this).data('url'), $(this).data('description'), $(this).data('id'))

    createSearchBox()

$(document).on('ready page:load', initialize);
