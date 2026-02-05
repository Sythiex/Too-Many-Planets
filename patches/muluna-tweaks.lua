local util = require("util")

-- thruster fuel and oxidizer unlock at same time
util.remove_tech_prereq("thruster-fuel", "thruster-oxidizer")
util.add_tech_prereq("thruster-fuel", "space-platform-thruster")
util.add_tech_prereq("thruster-fuel", "fluid-barreling")
util.set_craft_item_trigger("thruster-fuel", "thruster")

util.add_tech_prereq("planet-discovery-muluna", "thruster-oxidizer")
util.set_tech_trigger_fluid("planet-discovery-muluna", "thruster-oxidizer")
