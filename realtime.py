import wget
import time
from datetime import datetime
from datetime import date
import os.path
from os import path
import datastructure as ds
import json

# from protoc
import protobuf.data.gtfs_realtime_pb2 as rt

class RTVehiclePosition:
    def __init__(self, fleetid, tripid, blockid, scheduled, onroute, stopid, lat, lon):
        self.fleetid = fleetid
        self.tripid = tripid
        self.scheduled = scheduled
        self.onroute = onroute
        self.stopid = stopid
        self.blockid = blockid
        self.lat = lat
        self.lon = lon
        self.fleetnum = 'Unknown'
        self.unknown_fleetnum_flag = True

def make_realtime_filename():
    return 'gtfsrt_vehiclepos' + str(int(time.time())) + '.bin'

default_positions_file = 'data/realtime_downloads/default_gtfrealtime_VehiclePositions.bin'
vehicle_positions_path = default_positions_file
override_rt_flag = False  # for debug

# global
rtvehicle_dict = {}
id2fleetnum_dict = {}

victoria_gtfs_rt_url = 'http://victoria.mapstrat.com/current/gtfrealtime_VehiclePositions.bin'
last_rt_download_time = time.time()
# dynamically download the latest realtime files, save them somewhere with a logical path, update path variables here

def download_lastest_files():
    global vehicle_positions_path
    global last_rt_download_time
    print('Downloading latest gtfs-realtime files...')
    last_rt_download_time = time.time()
    fname = make_realtime_filename()
    fpath = 'data/realtime_downloads/' + fname
    try:
        wget.download(victoria_gtfs_rt_url, fpath)
        if path.exists(fpath):
            vehicle_positions_path = fpath  # update path to new download
    except:
        print('victoria GTFS download failed!')
        # now, test the date to see if we are out of date
        if(int(ds.get_today_str()) > int(ds.this_sheet_enddate)):
            print('THIS SHEET IS OUT OF DATE! Please reload the server lol')
    if override_rt_flag:  # for debug
        vehicle_positions_path = default_positions_file

def setup_fleetnums():
    global id2fleetnum_dict
    print('Realtime: Imported latest fleet numbers!')
    with open('data/nextride/id2fleetnum.json', 'r') as f:
        id2fleetnum_dict = json.load(f)

def get_data_refreshed_time_str():
    return time.asctime(time.localtime(last_rt_download_time))

def update_last_seen():
    global rtvehicle_dict
    with open('data/vehicle_history/last_seen.json', 'r') as f:
        last_seen = json.load(f)
    last_seen_times = last_seen['last_times']
    last_seen_blocks = last_seen['last_blocks']
    for fleetid in rtvehicle_dict.keys():
        rt_entry = rtvehicle_dict[fleetid]
        fleetnum = ''
        try:
            fleetnum = id2fleetnum_dict[fleetid]
        except AttributeError:
            continue
        last_seen_times[fleetnum] = {
        'day': str(date.today()),
        }
        if(rt_entry.scheduled and rt_entry.blockid != 'NONE'):
            last_seen_blocks[fleetnum] = {
            'blockid': rt_entry.blockid,
            'day': str(date.today()),
            'routes': ds.blockdict[rt_entry.blockid].get_block_routes()
            }
    last_seen['last_times'] = last_seen_times
    last_seen['last_blocks'] = last_seen_blocks
    with open('data/vehicle_history/last_seen.json', 'w') as f:
        last_seen = json.dump(last_seen, f)

def get_last_seen():
    with open('data/vehicle_history/last_seen.json', 'r') as f:
        last_seen = json.load(f)
    return last_seen
# just for interest
busidlist = []
count_scheduled = 0
count_unsched = 0

pos_data = None

def load_realtime():
    print('Loading the realtime data now...')
    global rtvehicle_dict
    global count_scheduled
    global count_unsched
    global busidlist
    global pos_data
    count_offroute = 0
    count_scheduled = 0
    count_unsched = 0
    busidlist = []
    rtvehicle_dict = {}
    with open(vehicle_positions_path, 'rb') as vpp_f:
        feed_message = rt.FeedMessage()
        feed_message.ParseFromString(vpp_f.read())

    pos_data = feed_message.entity
    for vehicle_struct in pos_data:
        try:
            bus = vehicle_struct.vehicle
            fleetid = bus.vehicle.id
        except AttributeError:
            print('What??? No vehicle and or id in this bus?')
            continue
        try:
            trip = bus.trip
            if(bus.stop_id != ''):
                stopid = bus.stop_id
                onroute = True
            else:
                onroute = False
                stopid = 'EMPTY'
                count_offroute += 1

            tripid = trip.trip_id
            if(trip.schedule_relationship == 0 and tripid != ''):
                scheduled = True
                blockid = ds.tripdict[tripid].blockid
                count_scheduled += 1

            else:
                scheduled = False
                count_unsched += 1
                blockid = 'NONE'
        except AttributeError:
            stopid = 'None: Not signed in'
            tripid = 'NONE'
            blockid = 'NONE'
            scheduled = False
            count_unsched += 1
            onroute = False
        try:
            pos = bus.position
            lat = pos.latitude
            lon = pos.longitude
        except AttributeError:
            print('No Lat Lon!')
            lat = 0
            lon = 0
        rtvehicle_dict[fleetid] = RTVehiclePosition(
            fleetid, tripid, blockid, scheduled, onroute, stopid, lat, lon)
        busidlist.append(fleetid)
    print('Populated the realtime structure...')
    print('Scheduled: {0} Unscheduled: {1} Total: {2}; Offroute: {3}'.format(
        count_scheduled, count_unsched, len(busidlist), count_offroute))
    setup_fleetnums()
    print('Fleet number translation list (from nextride) setup: {0} fleet numbers known'.format(
        len(id2fleetnum_dict)))
