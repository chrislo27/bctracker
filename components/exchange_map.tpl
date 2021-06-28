% import server
% import json

<div id="map"></div>
<script>
  const stops = JSON.parse('{{! json.dumps([s.json_data for s in stops]) }}')

  mapboxgl.accessToken = '{{server.mapbox_api_key}}';
  var map = new mapboxgl.Map({
    container: 'map',
    center: [0, 0],
    zoom: 1,
    style: 'mapbox://styles/mapbox/streets-v11',
    interactive: false
  });

  map.setStyle('mapbox://styles/mapbox/light-v10')

  map.on('load', function() {
    var lons = []
    var lats = []
    
    for (var stop of stops) {
      var marker = document.createElement("div");
      marker.className = "marker";
      marker.innerHTML = "<a href=\"/stop/" + stop.number +"\"><img src=\"/img/stop.png\" /><div><span>" + stop.number + "</span></div></a>";
  
      lons.push(stop.lon)
      lats.push(stop.lat)
  
      new mapboxgl.Marker(marker).setLngLat([stop.lon, stop.lat]).addTo(map);
    }

    const minLon = Math.min.apply(Math, lons)
    const maxLon = Math.max.apply(Math, lons)
    const minLat = Math.min.apply(Math, lats)
    const maxLat = Math.max.apply(Math, lats)
    map.fitBounds([[minLon, minLat], [maxLon, maxLat]], {
      duration: 0,
      padding: 40
    })
  });
</script>