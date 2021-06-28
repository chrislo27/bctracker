% rebase('base', title='Exchanges')

<h1>Exchanges</h1>
<hr />

% if system is None:
  <p>
    Exchanges can only be viewed for individual systems.
    Please choose a system.
  </p>
  % include('components/systems')
% else:
  % if len(system.exchanges) == 0:
    <p>
      {{ system }} does not have any exchanges.
      Please choose a different system.
    </p>
    % include('components/systems')
  % else:
    <table class="pure-table pure-table-horizontal pure-table-striped">
      <thead>
        <tr>
          <th>Name</th>
          <th class="desktop-only">Number of Stops</th>
          <th class="desktop-only">Routes</th>
        </tr>
      </thead>
      <tbody>
        % for exchange in system.all_exchanges():
          <tr>
            <td>
              <a href="{{ get_url(exchange.system, f'exchanges/{exchange.id}') }}">{{ exchange }}</a>
              <span class="mobile-only smaller-font">
                <br />
                {{ exchange.routes_string }}
              </span>
            </td>
            <td class="desktop-only">{{ len(exchange.stops) }}</td>
            <td class="desktop-only">{{ exchange.routes_string }}</td>
          </tr>
        % end
      </tbody>
    </table>
  % end
% end
