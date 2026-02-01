local util = require("util")

-- ------------------------------ Hovercraft requires flying robot frames, missile hovercraft requires rocket turrets ------------------------------

util.add_tech_prereq("hovercraft", "robotics")
util.add_tech_prereq("missile-hovercraft", "rocket-turret")
util.set_tech_unit("missile-hovercraft", 500,
              {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"military-science-pack", 1}, {"space-science-pack", 1}, {"agricultural-science-pack", 1}},
              60)

util.set_recipe("hovercraft", 4, {
    {
        type = "item",
        name = "iron-gear-wheel",
        amount = 20
    }, {
        type = "item",
        name = "steel-plate",
        amount = 10
    }, {
        type = "item",
        name = "flying-robot-frame",
        amount = 6
    }, {
        type = "item",
        name = "speed-module",
        amount = 2
    }, {
        type = "item",
        name = "efficiency-module",
        amount = 2
    }
})

util.set_recipe("missile-hovercraft", 4, {
    {
        type = "item",
        name = "hovercraft",
        amount = 1
    }, {
        type = "item",
        name = "advanced-circuit",
        amount = 40
    }, {
        type = "item",
        name = "gun-turret",
        amount = 2
    }, {
        type = "item",
        name = "rocket-turret",
        amount = 1
    }
})
