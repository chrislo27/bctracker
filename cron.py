
import os
import signal
from crontab import CronTab

CRON_ID = 'gtfs-muncher'
CRON_INTERVAL = 5

def start():
    signal.signal(signal.SIGUSR1, handle)
    pid = os.getpid()
    with CronTab(user=True) as cron:
        cron.remove_all(comment=CRON_ID)
        job = cron.new(command=f'kill -s USR1 {pid}', comment=CRON_ID)
        job.minute.every(CRON_INTERVAL)

def stop():
    with CronTab(user=True) as cron:
        cron.remove_all(comment=CRON_ID)

def handle(sig, frame):
    return