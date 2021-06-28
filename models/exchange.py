
class Exchange:
    def __init__(self, system, exchange_id, name):
        self.system = system
        self.id = exchange_id
        self.name = name
        self.stops = []
    
    def __str__(self):
        return self.name
    
    def __eq__(self, other):
        return self.id == other.id
    
    def __lt__(self, other):
        return self.id < other.id
    
    @property
    def routes(self):
        return sorted({ r for s in self.stops for r in s.routes })

    @property
    def routes_string(self):
        return ', '.join([str(r.number) for r in self.routes])
    
    def add_stop(self, stop):
        self.stops.append(stop)
        stop.exchange = self
