local util = require("util")

-- ------------------------------ Restore default Cargo Ships technologies ------------------------------

-- water_transport (Pelagos deletes this)
util.upsert_technology({
    type = "technology",
    name = "water_transport",
    icon = "__cargo-ships-graphics__/graphics/technology/water_transport.png",
    icon_size = 256,
    effects = {util.unlock_recipe("boat")},
    prerequisites = {"logistics-2", "engine"},
    unit = {
        count = 100,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-a"
})

-- automated_water_transport (Pelagos repurposes this to unlock cargo_ship)
util.clear_research_trigger("automated_water_transport")
util.upsert_technology({
    type = "technology",
    name = "automated_water_transport",
    icon = "__cargo-ships-graphics__/graphics/technology/automated_water_transport.png",
    icon_size = 256,
    effects = {util.unlock_recipe("port"), util.unlock_recipe("buoy"), util.unlock_recipe("chain_buoy")},
    prerequisites = {"water_transport"},
    unit = {
        count = 75,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-b"
})

-- cargo_ships (Pelagos deletes this)
util.upsert_technology({
    type = "technology",
    name = "cargo_ships",
    icon = "__cargo-ships-graphics__/graphics/technology/cargo_ships.png",
    icon_size = 256,
    effects = {util.unlock_recipe("cargo_ship")},
    prerequisites = {"automated_water_transport"},
    unit = {
        count = 150,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-a"
})

-- tank_ship (Pelagos moves this)
util.upsert_technology({
    type = "technology",
    name = "tank_ship",
    icon = "__cargo-ships-graphics__/graphics/technology/tank_ship.png",
    icon_size = 256,
    effects = {util.unlock_recipe("oil_tanker")},
    prerequisites = {"automated_water_transport", "fluid-handling"},
    unit = {
        count = 150,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-b"
})

-- ------------------------------ Fix Pelagos techs that depended on above techs ------------------------------

util.add_tech_prereq("deep_sea_oil_extraction", "coconut-processing-technology")
util.add_tech_prereq("deep_sea_oil_extraction", "cargo_ships")
util.remove_tech_prereq("deep_sea_oil_extraction", "automated_water_transport")

util.add_tech_prereq("lighthouse", "coconut-processing-technology")

-- ------------------------------ Restore default Cargo Ships recipes Pelagos overwrites ------------------------------

util.create_replacement_recipe("boat", "boat_default", 3, {
    {
        type = "item",
        name = "steel-plate",
        amount = 40
    }, {
        type = "item",
        name = "engine-unit",
        amount = 15
    }, {
        type = "item",
        name = "iron-gear-wheel",
        amount = 15
    }, {
        type = "item",
        name = "electronic-circuit",
        amount = 6
    }
})

util.create_replacement_recipe("cargo_ship", "cargo_ship_default", 15, {
    {
        type = "item",
        name = "steel-plate",
        amount = 220
    }, {
        type = "item",
        name = "engine-unit",
        amount = 50
    }, {
        type = "item",
        name = "iron-gear-wheel",
        amount = 60
    }, {
        type = "item",
        name = "electronic-circuit",
        amount = 20
    }
})

util.create_replacement_recipe("oil_tanker", "oil_tanker_no_sealant", 15, {
    {
        type = "item",
        name = "steel-plate",
        amount = 180
    }, {
        type = "item",
        name = "engine-unit",
        amount = 50
    }, {
        type = "item",
        name = "iron-gear-wheel",
        amount = 60
    }, {
        type = "item",
        name = "electronic-circuit",
        amount = 20
    }, {
        type = "item",
        name = "storage-tank",
        amount = 6
    }
})

util.set_recipe("buoy", 1, {
    {
        type = "item",
        name = "barrel",
        amount = 2
    }, {
        type = "item",
        name = "electronic-circuit",
        amount = 2
    }, {
        type = "item",
        name = "iron-plate",
        amount = 5
    }
})

util.set_recipe("chain_buoy", 1, {
    {
        type = "item",
        name = "barrel",
        amount = 2
    }, {
        type = "item",
        name = "electronic-circuit",
        amount = 2
    }, {
        type = "item",
        name = "iron-plate",
        amount = 5
    }
})
