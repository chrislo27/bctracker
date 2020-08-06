% import realtime as rt
% import businfotable as businfo
% import history as hist
% from formatting import format_date

% include('templates/header', title='Vehicle History')

<h1>Vehicle History</h1>
<hr />

<h2>Last Block Assigned</h2>
<p>For entries made under a older GTFS version, the block will no longer be valid</p>
<table class="pure-table pure-table-horizontal pure-table-striped">
  <thead>
    <tr>
      <th>Fleet Number</th>
      <th>Year and Model</th>
      <th>Date Last Assigned</th>
      <th>Assigned Routes</th>
      <th>Assigned Block</th>
    </tr>
  </thead>
  <tbody>
    % last_seen = hist.get_last_seen()
    % last_blocks = last_seen['last_blocks']
    % last_block_keys = list(last_blocks.keys())
    % last_block_keys.sort(key = lambda x: int(x))

    % last_times = last_seen['last_times']
    % last_times_keys = list(last_times.keys())
    % last_times_keys.sort(key = lambda x: int(x))
    % for fleetnum in last_block_keys:
      % if (fleetnum == '0'):
        % continue
      % end
      % obj = last_blocks[fleetnum]
      % busrange = businfo.get_bus_range(fleetnum)
      <tr>
        <td><a href="/bus/number/{{fleetnum}}">{{ fleetnum }}</a></td>
        <td>{{ busrange.year }} {{ busrange.model }}</td>
        <td>{{ format_date(obj['day']) }}</td>
        <td>{{ ', '.join(sorted(obj['routes'])) }}</td>
        <td><a href="/blocks/{{obj['blockid']}}">{{ obj['blockid'] }}</a></td>
      </tr>
    % end
  </tbody>
</table>

<h2>Last Time Tracked</h2>
<p>The last time the vehicle was detected by the tracker even if it wasn't assigned to a route</p>
<table class="pure-table pure-table-horizontal pure-table-striped">
  <thead>
    <tr>
      <th>Fleet Number</th>
      <th>Year and Model</th>
      <th>Date Last Active</th>
    </tr>
  </thead>
  <tbody>
    % for fleetnum in last_times_keys:
      % if (fleetnum == '0'):
        % continue
      % end
      % date = last_times[fleetnum]['day']
      % busrange = businfo.get_bus_range(fleetnum)
      <tr>
        <td><a href="/bus/number/{{fleetnum}}">{{ fleetnum }}</a></td>
        <td>{{ busrange.year }} {{ busrange.model }}</td>
        <td>{{ format_date(date) }}</td>
      </tr>
    % end
  </tbody>
</table>

% include('templates/footer')
