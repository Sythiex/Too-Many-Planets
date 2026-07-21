local util = require("util")

-- thruster fuel and oxidizer unlock at same time
if mods["planet-muluna"] and settings.startup["tmp-muluna-tech-qol"].value == true then
    util.remove_tech_prereq("thruster-fuel", "thruster-oxidizer")
    util.add_tech_prereq("thruster-fuel", "space-platform-thruster")
    util.add_tech_prereq("thruster-fuel", "fluid-barreling")
    util.set_tech_trigger_item("thruster-fuel", "thruster")

    util.add_tech_prereq("planet-discovery-muluna", "thruster-oxidizer")
    -- util.set_tech_trigger_fluid("planet-discovery-muluna", "thruster-oxidizer")
end

-- add Muluna exploration science to Asteroid Belt space discovery
if mods["AsteroidBelt"] and mods["planet-muluna"] and settings.startup["tmp-asteroid-belt-requires-interstellar-science"].value == true then
    util.add_tech_ingredient("space-discovery-asteroid-belt", "interstellar-science-pack", 1)
    util.add_tech_prereq("space-discovery-asteroid-belt", "interstellar-science-pack")
end

-- add Muluna exploration science to Cubium planet discovery
if mods["cubium"] and mods["planet-muluna"] and settings.startup["tmp-cubium-requires-interstellar-science"].value == true then
    util.add_tech_ingredient("planet-discovery-cubium", "interstellar-science-pack", 1)
    util.add_tech_prereq("planet-discovery-cubium", "interstellar-science-pack")
end
