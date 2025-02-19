% import json

<div id="map"></div>
<script>
    const lat = parseFloat("{{stop.lat}}");
    const lon = parseFloat("{{stop.lon}}");
    
    const map = new mapboxgl.Map({
        container: 'map',
        center: [lon, lat],
        zoom: 14,
        style: prefersDarkScheme ? 'mapbox://styles/mapbox/dark-v10' : 'mapbox://styles/mapbox/light-v10',
        interactive: false
    });
    
    const element = document.createElement('div');
    element.className = 'marker';
    element.innerHTML = '<img src="/img/stop.png" />'
    
    new mapboxgl.Marker(element).setLngLat([lon, lat]).addTo(map);
</script>
