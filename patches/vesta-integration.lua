local util = require("util")

if mods["skewer_planet_vesta"] and settings.startup["tmp-vesta-main-progression"].value == true then
    util.add_tech_prereq("promethium-science-pack", "s1_gas_manipulation_science_pack")
    data.raw.technology["s1_gas_manipulation_science_pack"].essential = true
    util.add_tech_ingredient("promethium-science-pack", "gas-manipulation-science-pack", 1)
end
