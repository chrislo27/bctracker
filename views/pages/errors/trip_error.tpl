% rebase('base', title='Error')

<h1>Error: Trip {{ trip_id }} Not Found</h1>
<hr />

<p>The trip you are looking for doesn't seem to exist!</p>
<p>
    There are a few reasons why that might be the case:
    <ol>
        <li>It may be from an older sheet that is no longer active</li>
        <li>It may be the wrong ID - are you sure trip {{ trip_id }} is the one you want?</li>
        % alt_systems = [s for s in systems if s.get_trip(trip_id) is not None]
        % if len(alt_systems) > 0:
            <li>
                It may be from a different system - the following systems have a trip with that ID
                <ul>
                    % for alt_system in alt_systems:
                        <li>{{ alt_system }}: <a href="{{ get_url(alt_system, f'trips/{trip_id}') }}">Trip {{ trip_id }}</a></li>
                    % end
                </ul>
            </li>
        % end
    </ol>
</p>

<p>
    If you believe this error is incorrect and the trip actually should exist, please email <a href="mailto:james@bctracker.ca">james@bctracker.ca</a> to let us know!
</p>

<p>
    <button class="button" onclick="window.history.back()">Back</button>
</p>
