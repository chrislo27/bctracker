#!/bin/sh

pip install wget
pip install Bottle
pip install cherrypy
pip install wsgi-request-logger
pip install protobuf
pip install google
mkdir -p data/realtime_downloads
mkdir -p logs
chmod +x download_new_gtfs.sh
chmod +x download_new_routes.sh
./download_new_gtfs.sh
./download_new_routes.sh
