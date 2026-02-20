local util = require("util")

-- thruster fuel and oxidizer unlock at same time
if mods["planet-muluna"] and settings.startup["tmp-muluna-tech-qol"].value == true then
    util.remove_tech_prereq("thruster-fuel", "thruster-oxidizer")
    util.add_tech_prereq("thruster-fuel", "space-platform-thruster")
    util.add_tech_prereq("thruster-fuel", "fluid-barreling")
    util.set_tech_trigger_item("thruster-fuel", "thruster")

    util.add_tech_prereq("planet-discovery-muluna", "thruster-oxidizer")
    util.set_tech_trigger_fluid("planet-discovery-muluna", "thruster-oxidizer")
end
