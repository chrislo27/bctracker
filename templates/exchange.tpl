% rebase('base', title=str(exchange), include_maps=True)

<h1>{{ exchange }}</h1>
<hr />

<div class="sidebar">
  % include('components/exchange_map', stops=exchange.stops)
  
  <div class="info-box">
    <div class="info-box-section">
      <div class="info-box-name">Stops</div>
      <div class="info-box-value">{{ len(exchange.stops) }}</div>
    </div>
    <div class="info-box-section">
      <div class="info-box-name">Route{{ '' if len(exchange.routes) == 1 else 's' }}</div>
      <div class="info-box-value">
        % for route in exchange.routes:
          <a href="{{ get_url(route.system, f'routes/{route.number}') }}">{{ route }}</a>
          <br />
        % end
      </div>
    </div>
  </div>
</div>

<table class="pure-table pure-table-horizontal pure-table-striped">
  <thead>
    <tr>
      <th class="desktop-only">Stop Number</th>
      <th class="desktop-only">Stop Name</th>
      <th class="mobile-only">Stop</th>
      <th>Routes</th>
    </tr>
  </thead>
  <tbody>
    % for stop in exchange.stops:
      <tr>
        <td>
          <a href="{{ get_url(stop.system, f'stops/{stop.number}') }}">{{ stop.number }}</a>
          <span class="mobile-only smaller-font">
            <br />
            {{ stop }}
          </span>
        </td>
        <td class="desktop-only">{{ stop }}</td>
        <td>{{ stop.routes_string }}</td>
      </tr>
    % end
  </tbody>
</table>
