% rebase('base', title='Routes')

<h1>Routes</h1>
<hr />

% if system is None:
  <p>
    Routes can only be viewed for individual systems.
    Please choose a system.
  </p>
  % include('components/systems')
% else:
  <table class="pure-table pure-table-horizontal pure-table-striped">
    <thead>
      <tr>
        <th>Route</th>
      </tr>
    </thead>
    <tbody>
      % for route in system.all_routes():
        <tr>
          <td><a href="{{ get_url(route.system, f'routes/{route.number}') }}">{{ route }}</a></td>
        </tr>
      % end
    </tbody>
  </table>
% end
