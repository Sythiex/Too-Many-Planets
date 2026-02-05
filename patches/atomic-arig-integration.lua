local util = require("util")

-- Move Arig to be locked behind Asteroid Collector (same as other starter planet discoveries, improves compat with Muluna)
util.add_tech_prereq("planet-discovery-arig", "asteroid-collector")

-- change research time 30 → 60 (same as other starter planet discoveries)
util.set_tech_unit("planet-discovery-arig", 1000, {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"space-science-pack", 1}}, 60)
