local util = {}

-- Adds prereq_name to tech_name.prerequisites (if both techs exist, and not already present)
function util.add_tech_prereq(tech_name, prereq_name)
    local tech = data.raw.technology[tech_name]
    local prereq = data.raw.technology[prereq_name]
    if not tech or not prereq then
        return false
    end

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
function util.remove_tech_prereq(tech_name, prereq_name)
    local tech = data.raw.technology[tech_name]
    if not tech or not tech.prerequisites then
        return false
    end

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

function util.unlock_recipe(recipe)
    return {
        type = "unlock-recipe",
        recipe = recipe
    }
end

function util.clear_research_trigger(name)
    local t = data.raw.technology[name]
    if t then
        t.research_trigger = nil
    end
end

function util.set_tech_trigger_item(tech_name, item_filter, count)
    local t = data.raw.technology[tech_name]
    if not t then
        return false
    end
    t.research_trigger = {
        type = "craft-item",
        item = item_filter,
        count = count or 1
    }
    t.unit = nil
    return true
end

function util.set_tech_trigger_fluid(tech_name, fluid)
    local t = data.raw.technology[tech_name]
    if not t then
        return false
    end
    t.research_trigger = {
        type = "craft-fluid",
        fluid = "thruster-fuel"
    }
    t.unit = nil
    return true
end

function util.upsert_technology(proto)
    local existing = data.raw.technology[proto.name]
    if existing then
        for k, v in pairs(proto) do
            existing[k] = v
        end
    else
        data:extend({proto})
    end
end

--- tech_name: Technology prototype name (string)
--- count: Total number of research cycles (integer) (optional)
--- ingredients: Science packs required per cycle (table) (optional)
--- time: Seconds per cycle (number) (optional)
function util.set_tech_unit(tech_name, count, ingredients, time)
    local tech = data.raw.technology[tech_name]
    if not tech then
        return false
    end

    tech.unit = tech.unit or {}

    tech.unit.count_formula = nil

    if count ~= nil then
        tech.unit.count = count
    end
    if ingredients ~= nil then
        tech.unit.ingredients = ingredients
    end
    if time ~= nil then
        tech.unit.time = time
    end

    return true
end

function util.set_recipe(name, energy_required, ingredients)
    local r = data.raw.recipe[name]
    if not r then
        return
    end
    r.energy_required = energy_required
    r.ingredients = ingredients
end

-- Hide + disable a recipe so it won't show up / be craftable by players
function util.hide_recipe(name)
    local r = data.raw.recipe[name]
    if not r then
        return false
    end

    r.hidden = true
    r.hide_from_player_crafting = true
    r.enabled = false
    return true
end

return util
