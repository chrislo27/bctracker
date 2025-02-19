% from formatting import format_date, format_date_mobile

% rebase('base', title='Vehicle History')

<div class="page-header">
    <h1 class="title">Vehicle History</h1>
</div>
<hr />

<div class="body">
    % if system is not None and not system.realtime_enabled:
        <p>
            {{ system }} does not currently support realtime.
            You can browse the schedule data for {{ system }} using the links above, or choose another system that supports realtime from the following list.
        </p>
        
        % include('components/systems', realtime_only=True)
    % else:
        <table class="pure-table pure-table-horizontal pure-table-striped">
            <thead>
                <tr>
                    <th class="desktop-only">Number</th>
                    <th class="desktop-only">Model</th>
                    <th class="non-desktop">Bus</th>
                    <th>Last Seen</th>
                    % if system is None:
                        <th class="non-mobile">System</th>
                    % end
                    <th class="desktop-only">Assigned Block</th>
                    <th class="desktop-only">Assigned Routes</th>
                    <th class="non-desktop">Block</th>
                </tr>
            </thead>
            <tbody>
                % last_bus = None
                % for history in last_seen:
                    % bus = history.bus
                    % same_model = last_bus is None or bus.order == last_bus.order
                    % last_bus = bus
                    % order = bus.order
                    <tr class="{{'' if same_model else 'divider'}}">
                        <td>
                            <a href="{{ get_url(system, f'bus/{bus.number}') }}">{{ bus }}</a>
                            % if order is not None:
                                <span class="non-desktop smaller-font">
                                    <br />
                                    {{ order }}
                                </span>
                            % end
                        </td>
                        <td class="desktop-only">
                            % if order is not None:
                                {{ order }}
                            % end
                        </td>
                        <td class="desktop-only">{{ format_date(history.date) }}</td>
                        <td class="non-desktop no-wrap">{{ format_date_mobile(history.date) }}</td>
                        % if system is None:
                            <td class="non-mobile">{{ history.system }}</td>
                        % end
                        <td>
                            % if history.is_available:
                                % block = history.block
                                <a href="{{ get_url(block.system, f'blocks/{block.id}') }}">{{ block.id }}</a>
                            % else:
                                <span>{{ history.block_id }}</span>
                            % end
                        </td>
                        <td class="desktop-only">{{ history.routes_string }}</td>
                    </tr>
                % end
            </tbody>
        </table>
    % end
</div>