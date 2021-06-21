# This script takes the JSON last_seen file created
# by the old implementation (before multiple systems
# were added) and updates it as best as possible to
# match the new format.

import json

OLD_PATH = 'last_seen.json'
NEW_PATH = 'data/history/last_seen.json'

with open(OLD_PATH, 'r') as file:
    old_data = json.load(file)

new_data = []

for key, value in old_data['last_blocks'].items():
    if key == '0' and value['blockid'] == '12345':
        continue
    new_data.append({
        'date': value['day'],
        'bus_id': '',
        'number': int(key),
        'system_id': 'victoria',
        'feed_version': '',
        'block_id': value['blockid'],
        'routes': [int(r) for r in value['routes']]
    })

with open(NEW_PATH, 'w') as file:
    json.dump({ 'last_seen': new_data }, file)
