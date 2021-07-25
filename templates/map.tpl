% import json

% rebase('base', title='Map', include_maps=True)

% if len(buses) == 0:
  <h1>Map</h1>
  <hr />

  % if system is not None and not system.realtime_enabled:
    <p>
      {{ system }} does not currently support realtime.
      You can browse the schedule data for {{ system }} using the links above, or choose another system that supports realtime from the following list.
    </p>

    % include('components/systems', realtime_only=True)
  % else:
    % if system is None:
      <p>
        There are no buses out right now.
        BC Transit does not have late night service, so this should be the case overnight.
        If you look out your window and the sun is shining, there may be an issue with the GTFS getting up-to-date info.
        Please check back later!
      </p>
    % else:
      <p>
        There are no buses out in {{ system }} right now. Please choose a different system.
      </p>

      % include('components/systems', realtime_only=True)
    % end
  % end
% else:
  <div class="system-map-header">
    <h1>Map</h1>
    <div class="checkbox-button" onclick="toggleTripLines()">
      <div class="checkbox">
        <img class="checkbox-image" id="checkbox-image" src="/img/check.png" />
      </div>
      <span class="checkbox-label">Show Routes</span>
    </div>
  </div>

  <div id="system-map"></div>
  
  <script>
    mapboxgl.accessToken = "{{mapbox_api_key}}";
    var map = new mapboxgl.Map({
      container: "system-map",
      center: [0, 0],
      zoom: 1,
      style: "mapbox://styles/mapbox/light-v10"
    });
  
    const buses = JSON.parse('{{! json.dumps([b.json_data for b in buses if b.position.has_location]) }}');
  
    var lons = []
    var lats = []
    
    for (var bus of buses) {
      var marker = document.createElement("div");
      marker.className = "marker";
      marker.innerHTML = "\
        <div class='marker-link'></div>\
        <a href=\"/bus/" + bus.number +"\">\
          <img src=\"/img/bus.png\" />\
          <div class='marker-bus'><span>" + bus.number + "</span></div>\
          <div class='marker-headsign'><span>" + bus.headsign + "</span></div>\
        </a>";
      marker.style.backgroundColor = "#" + bus.colour;
  
      lons.push(bus.lon)
      lats.push(bus.lat)
  
      new mapboxgl.Marker(marker).setLngLat([bus.lon, bus.lat]).addTo(map);
    }
  
    if (lons.length === 1 && lats.length === 1) {
      map.jumpTo({
        center: [lons[0], lats[0]],
        zoom: 14
      })
    } else {
      const minLon = Math.min.apply(Math, lons)
      const maxLon = Math.max.apply(Math, lons)
      const minLat = Math.min.apply(Math, lats)
      const maxLat = Math.max.apply(Math, lats)
      map.fitBounds([[minLon, minLat], [maxLon, maxLat]], {
        duration: 0,
        padding: {top: 200, bottom: 100, left: 100, right: 100}
      })
    }

    map.on("load", function() {
      for (var bus of buses) {
        if (bus.points === null || bus.points === undefined) {
          continue
        }
        map.addSource(bus.number + '_route', {
          'type': 'geojson',
          'data': {
            'type': 'Feature',
            'properties': {},
            'geometry': {
              'type': 'LineString',
              'coordinates': bus.points.map(function (point) { return [point.lon, point.lat] })
            }
          }
        });
        map.addLayer({
          'id': bus.number + '_route',
          'type': 'line',
          'source': bus.number + '_route',
          'layout': {
            'line-join': 'round',
            'line-cap': 'round'
          },
          'paint': {
            'line-color': '#' + bus.colour,
            'line-width': 4
          }
        });
      }
    })

    let tripLinesVisible = true

    function toggleTripLines() {
      tripLinesVisible = !tripLinesVisible;
      let checkboxImage = document.getElementById("checkbox-image");
      if (tripLinesVisible) {
        checkboxImage.className = "checkbox-image";
      } else {
        checkboxImage.className = "checkbox-image hidden";
      }

      for (var bus of buses) {
        if (bus.points === null || bus.points === undefined) {
          continue
        }
        map.setLayoutProperty(bus.number + "_route", "visibility", tripLinesVisible ? "visible" : "none");
      }
    }
  </script>
% end
