local util = require("util")

if mods["pelagos"] then
    if settings.startup["tmp-pelagos-before-gleba"].value == true then
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
        data.raw["recipe"]["fermentation-bacteria"].category = "organic-or-chemistry"
    end

    if settings.startup["tmp-pelagos-fishing"].value == true then
        if mods["fishing-boat"] and mods["fishing-dock"] then
            util.add_tech_prereq("fishing-dock", "fishing-boat")
        end

        if mods["fishing-boat"] then
            util.add_tech_prereq("fishing-boat", "planet-discovery-pelagos")
        end

        if mods["fishing-dock"] then
            util.remove_tech_prereq("fishing-dock", "fish-breeding")
            util.remove_tech_prereq("fishing-dock", "captivity")
            util.add_tech_prereq("fishing-dock", "fermentation-bacteria-cultivation-technology")
            util.set_tech_trigger_item("fishing-dock", "fishing-boat")
            util.set_recipe("fishing-bait-pelagos", 5, {
                {
                    type = "item",
                    name = "fermented-fish",
                    amount = 1
                }, {
                    type = "item",
                    name = "copper-cable",
                    amount = 2
                }
            })
            util.set_recipe_result("fishing-bait-pelagos", "fishing-bait", 2)
        end
    end
end
