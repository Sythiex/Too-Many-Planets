local util = require("util")

-- Move Planet Discovery Pelagos out from behind Gleba
util.remove_tech_prereq("planet-discovery-pelagos", "fish-breeding")
util.remove_tech_prereq("planet-discovery-pelagos", "captivity")
util.remove_tech_prereq("planet-discovery-pelagos", "agricultural-science-pack")
util.add_tech_prereq("planet-discovery-pelagos", "asteroid-collector")
util.set_tech_unit("planet-discovery-pelagos", 1000, {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"space-science-pack", 1}}, 60)

-- Make Copper Spitter Captivity a joint Gleba tech
util.add_tech_prereq("copper-biter-captivity", "captivity")
util.add_tech_prereq("copper-biter-captivity", "pelagos-science-pack")
util.clear_research_trigger("copper-biter-captivity")
util.set_tech_unit("copper-biter-captivity", 500, {
    {"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"space-science-pack", 1}, {"agricultural-science-pack", 1}, {"pelagos-science-pack", 1}
}, 30)

-- Add bootstrap fermentation bacteria recipe to chemical plants
if data.raw["recipe"]["fermentation-bacteria"] then
    data.raw["recipe"]["fermentation-bacteria"].category = "organic-or-chemistry"
end

-- Move fishing boat to Pelagos
util.add_tech_prereq("fishing-boat", "planet-discovery-pelagos")

-- Add fishing dock to Pelagos
util.remove_tech_prereq("fishing-dock", "fish-breeding")
util.remove_tech_prereq("fishing-dock", "captivity")
util.add_tech_prereq("fishing-dock", "fishing-boat")
util.add_tech_prereq("fishing-dock", "fermentation-bacteria-cultivation-technology")
util.set_tech_trigger_item("fishing-dock", "fishing-boat")
util.set_recipe("fishing-bait-pelagos", 5, {
    {
        type = "item",
        name = "fermented-fish",
        amount = 2
    }, {
        type = "item",
        name = "copper-cable",
        amount = 5
    }
})

-- Move Ironclad behind Galleon Weaponry
util.add_tech_prereq("ironclad", "Pirate_Ship")
