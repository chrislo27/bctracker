% import json

<div id="map"></div>
<script>
    const map = new mapboxgl.Map({
        container: 'map',
        center: [0, 0],
        zoom: 1,
        style: prefersDarkScheme ? 'mapbox://styles/mapbox/dark-v10' : 'mapbox://styles/mapbox/light-v10',
        interactive: false
    });
    
    const lons = [];
    const lats = [];
</script>

% shape_ids = {t.shape_id for t in route.trips}
% for shape_id in shape_ids:
    % points = sorted(route.system.get_shape(shape_id).points)
    <script>
        map.on('load', function() {
            const points = JSON.parse('{{! json.dumps([p.json_data for p in points]) }}');
            
            map.addSource('{{shape_id}}', {
                'type': 'geojson',
                'data': {
                    'type': 'Feature',
                    'properties': {},
                    'geometry': {
                        'type': 'LineString',
                        'coordinates': points.map(function (point) { return [point.lon, point.lat] })
                    }
                }
            });
            map.addLayer({
                'id': '{{shape_id}}',
                'type': 'line',
                'source': '{{shape_id}}',
                'layout': {
                    'line-join': 'round',
                    'line-cap': 'round'
                },
                'paint': {
                    'line-color': '#{{route.colour}}',
                    'line-width': 4
                }
            });
            
            for (point of points) {
                lons.push(point.lon);
                lats.push(point.lat);
            }
        });
    </script>
% end

<script>
    map.on('load', function() {
        const minLon = Math.min.apply(Math, lons)
        const maxLon = Math.max.apply(Math, lons)
        const minLat = Math.min.apply(Math, lats)
        const maxLat = Math.max.apply(Math, lats)
        map.fitBounds([[minLon, minLat], [maxLon, maxLat]], {
            duration: 0,
            padding: 20
        })
    })
</script>