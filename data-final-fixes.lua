local function tech_exists(name) return data.raw.technology and data.raw.technology[name] ~= nil end

-- Adds prereq_name to tech_name.prerequisites (if both techs exist, and not already present)
local function add_tech_prereq(tech_name, prereq_name)
    local tech = data.raw.technology[tech_name]
    local prereq = data.raw.technology[prereq_name]
    if not tech or not prereq then return false end

    tech.prerequisites = tech.prerequisites or {}

    for _, name in ipairs(tech.prerequisites) do
        if name == prereq_name then
            return true -- already present
        end
    end

    table.insert(tech.prerequisites, prereq_name)
    return true
end

-- Removes prereq_name from tech_name.prerequisites (if tech exists)
local function remove_tech_prereq(tech_name, prereq_name)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.prerequisites then return false end

    local out = {}
    local removed = false
    for _, name in ipairs(tech.prerequisites) do
        if name ~= prereq_name then
            table.insert(out, name)
        else
            removed = true
        end
    end

    tech.prerequisites = out
    return removed
end

local function has_prereq(tech, prereq_name)
    if not (tech and tech.prerequisites) then return false end
    for _, p in ipairs(tech.prerequisites) do if p == prereq_name then return true end end
    return false
end

local function unlock(recipe)
    return {
        type = "unlock-recipe",
        recipe = recipe
    }
end

local function clear_research_trigger(name)
    local t = data.raw.technology[name]
    if t then t.research_trigger = nil end
end

local function upsert_technology(proto)
    local existing = data.raw.technology[proto.name]
    if existing then
        for k, v in pairs(proto) do existing[k] = v end
    else
        data:extend({proto})
    end
end

local function set_tech_unit(tech_name, count, ingredients, time)
    local tech = data.raw.technology[tech_name]
    if not tech then return false end

    tech.unit = tech.unit or {}

    tech.unit.count_formula = nil

    if count ~= nil then tech.unit.count = count end
    if ingredients ~= nil then tech.unit.ingredients = ingredients end
    if time ~= nil then tech.unit.time = time end

    return true
end

local function set_recipe(name, energy_required, ingredients)
    local r = data.raw.recipe[name]
    if not r then return end
    r.energy_required = energy_required
    r.ingredients = ingredients
end

-- ---- Restore default Cargo Ships technologies ----

-- water_transport (Pelagos deletes this)
upsert_technology({
    type = "technology",
    name = "water_transport",
    icon = "__cargo-ships-graphics__/graphics/technology/water_transport.png",
    icon_size = 256,
    effects = {unlock("boat")},
    prerequisites = {"logistics-2", "engine"},
    unit = {
        count = 100,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-a"
})

-- automated_water_transport (Pelagos repurposes this to unlock cargo_ship + remove unit)
clear_research_trigger("automated_water_transport")
upsert_technology({
    type = "technology",
    name = "automated_water_transport",
    icon = "__cargo-ships-graphics__/graphics/technology/automated_water_transport.png",
    icon_size = 256,
    effects = {unlock("port"), unlock("buoy"), unlock("chain_buoy")},
    prerequisites = {"water_transport"},
    unit = {
        count = 75,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-b"
})

-- cargo_ships (Pelagos deletes this)
upsert_technology({
    type = "technology",
    name = "cargo_ships",
    icon = "__cargo-ships-graphics__/graphics/technology/cargo_ships.png",
    icon_size = 256,
    effects = {unlock("cargo_ship")},
    prerequisites = {"automated_water_transport"},
    unit = {
        count = 150,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-a"
})

-- tank_ship (Pelagos moves this)
upsert_technology({
    type = "technology",
    name = "tank_ship",
    icon = "__cargo-ships-graphics__/graphics/technology/tank_ship.png",
    icon_size = 256,
    effects = {unlock("oil_tanker")},
    prerequisites = {"automated_water_transport", "fluid-handling"},
    unit = {
        count = 150,
        ingredients = {{"automation-science-pack", 1}, {"logistic-science-pack", 1}},
        time = 30
    },
    order = "c-g-b"
})

-- ---- Fix Pelagos techs that depended on above techs ----

add_tech_prereq("deep_sea_oil_extraction", "coconut-processing-technology")
add_tech_prereq("deep_sea_oil_extraction", "cargo_ships")
remove_tech_prereq("deep_sea_oil_extraction", "automated_water_transport")

add_tech_prereq("lighthouse", "coconut-processing-technology")

-- ---- Restore default Cargo Ships recipes Pelagos overwrites ----

-- boat
set_recipe("boat", 3, {
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

-- cargo_ship
set_recipe("cargo_ship", 15, {
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

-- oil_tanker
set_recipe("oil_tanker", 15, {
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

-- buoy
set_recipe("buoy", 1, {
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

-- chain_buoy
set_recipe("chain_buoy", 1, {
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

-- ---- Restore default Ironclad technologies ----

upsert_technology({
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

-- ---- Battleship requires ironclad, artillery, and rocket turrets ----

upsert_technology({
    type = "technology",
    name = "battleship",
    -- icon = "__cargo-ships-graphics__/graphics/technology/cargo_ships.png",
    icon_size = 256,
    effects = {unlock("battleship"), unlock("patrol-boat")},
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

-- ---- Hovercraft requires flying robot frames, missile hovercraft requires rocket turrets ----

add_tech_prereq("hovercraft", "robotics")
add_tech_prereq("missile-hovercraft", "rocket-turret")
set_tech_unit("missile-hovercraft", 500,
              {{"automation-science-pack", 1}, {"logistic-science-pack", 1}, {"chemical-science-pack", 1}, {"military-science-pack", 1}, {"space-science-pack", 1}, {"agricultural-science-pack", 1}},
              60)

set_recipe("hovercraft", 4, {
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

set_recipe("missile-hovercraft", 4, {
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

-- ---- Hoverbike requires hovercraft ----

add_tech_prereq("hyper-bike", "hovercraft")

-- ---- AAI Loaders balancing ----

-- set_recipe("aai-wood-loader", 10, {
--     {
--         type = "item",
--         name = "lumber",
--         amount = 10
--     }, {
--         type = "item",
--         name = "basic-circuit-board",
--         amount = 25
--     }, {
--         type = "item",
--         name = "wood-transport-belt",
--         amount = 1
--     }
-- })

-- set_recipe("aai-loader", 10, {
--     {
--         type = "item",
--         name = "iron-plate",
--         amount = 25
--     }, {
--         type = "item",
--         name = "electronic-circuit",
--         amount = 25
--     }, {
--         type = "item",
--         name = "transport-belt",
--         amount = 1
--     }
-- })

-- set_recipe("aai-fast-loader", 10, {
--     {
--         type = "item",
--         name = "iron-gear-wheel",
--         amount = 50
--     }, {
--         type = "item",
--         name = "electronic-circuit",
--         amount = 50
--     }, {
--         type = "item",
--         name = "aai-loader",
--         amount = 1
--     }
-- })