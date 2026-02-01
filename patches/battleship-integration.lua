local util = require("util")

-- ------------------------------ Battleship requires ironclad, artillery, and rocket turrets ------------------------------

util.upsert_technology({
    type = "technology",
    name = "battleship",
    -- icon = "__cargo-ships-graphics__/graphics/technology/cargo_ships.png",
    icon_size = 256,
    effects = {util.unlock_recipe("battleship"), util.unlock_recipe("patrol-boat")},
    prerequisites = {"cargo_ships", "ironclad", "artillery", "rocket-turret"},
    unit = {
        count = 2500,
        ingredients = {
            {"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"military-science-pack", 1}, {"chemical-science-pack", 1}, {"utility-science-pack", 1}, {"space-science-pack", 1},
            {"metallurgic-science-pack", 1}, {"agricultural-science-pack", 1}
        },
        time = 30
    },
    order = "c-g-a"
})
