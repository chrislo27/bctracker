% if get('realtime_only', False):
	% available_systems = [s for s in systems if s.realtime_enabled]
% else:
  % available_systems = systems
% end

<table class="pure-table pure-table-horizontal pure-table-striped">
	<thead>
		<tr>
			<th>System</th>
		</tr>
	</thead>
	<tbody>
		% if system is None:
			% for available_system in sorted(available_systems):
				<tr>
					<td><a href="{{ get_url(available_system, get('path', '')) }}">{{ available_system }}</a></td>
				</tr>
			% end
		% else:
			<td><a href="{{ get_url(None, get('path', '')) }}">All Systems</a></td>
			% for available_system in sorted(available_systems):
				% if system != available_system:
					<tr>
						<td><a href="{{ get_url(available_system, get('path', '')) }}">{{ available_system }}</a></td>
					</tr>
				% end
			% end
		% end
	</tbody>
</table>
