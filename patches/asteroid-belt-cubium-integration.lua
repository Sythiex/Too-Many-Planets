local util = require("util")

if mods["AsteroidBelt"] and mods["cubium"] then
    util.add_tech_prereq("planet-discovery-cubium", "space-discovery-asteroid-belt")
end
