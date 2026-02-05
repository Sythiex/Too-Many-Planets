local util = require("util")

-- Move Arig to be locked behind Asteroid Collector (same as other starter planet discoveries)
util.add_tech_prereq("planet-discovery-arig", "asteroid-collector")
