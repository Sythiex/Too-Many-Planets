local util = require("util")

-- ------------------------------ Move Ironclad tech from Pelagos back to Nauvis (requires Cargo Ships, comparable to tank) ------------------------------

util.upsert_technology({
    type = "technology",
    name = "ironclad",
    icon_size = 256,
    icon = "__aai-vehicles-ironclad__/graphics/technology/ironclad.png",
    effects = {
        {
            type = "unlock-recipe",
            recipe = "ironclad"
        }, {
            type = "unlock-recipe",
            recipe = "mortar-bomb"
        }, {
            type = "unlock-recipe",
            recipe = "mortar-cluster-bomb"
        }
    },
    prerequisites = {"water_transport", "military-3", "explosives"},
    unit = {
        count = 250,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"military-science-pack", 1}},
        time = 30
    },
    order = "e-c-c"
})
