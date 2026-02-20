local util = require("util")

if mods["pelagos"] then
    -- coconut processing no longer requires productivity modules to sustain
    if settings.startup["tmp-pelagos-coconut-seed-buff"].value == true then
        data.raw.recipe["coconut-processing"].results = {
            {
                type = "item",
                name = "coconut-seed",
                amount = 1,
                probability = 0.1
            }, {
                type = "item",
                name = "coconut-meat",
                amount = 2
            }, {
                type = "item",
                name = "coconut-husk",
                amount = 2
            }
        }
    end

    -- Move Ironclad behind Galleon Weaponry
    if mods["aai-vehicles-ironclad"] and settings.startup["tmp-pelagos-ironclad-requires-galleon"].value == true then
        util.add_tech_prereq("ironclad", "Pirate_Ship")
    end
end
