local util = {}

-- Adds prereq_name to tech_name.prerequisites (if both techs exist, and not already present)
function util.add_tech_prereq(tech_name, prereq_name)
    local tech = data.raw.technology[tech_name]
    local prereq = data.raw.technology[prereq_name]
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
    data.raw.technology[name].research_trigger = nil
end

function util.set_tech_trigger_item(tech_name, item_filter, count)
    local t = data.raw.technology[tech_name]
    t.research_trigger = {
        type = "craft-item",
        item = item_filter,
        count = count or 1
    }
    t.unit = nil
    return
end

function util.set_tech_trigger_fluid(tech_name, fluid)
    local t = data.raw.technology[tech_name]
    t.research_trigger = {
        type = "craft-fluid",
        fluid = "thruster-fuel"
    }
    t.unit = nil
    return
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

    return
end

function util.set_recipe(name, energy_required, ingredients)
    local r = data.raw.recipe[name]
    r.energy_required = energy_required
    r.ingredients = ingredients
end

function util.set_recipe_result(recipe_name, result_name, amount, result_type)
    local recipe = data.raw.recipe[recipe_name]

    local new_result = {
        type = result_type or "item",
        name = result_name,
        amount = amount or 1
    }

    recipe.result = nil
    recipe.result_count = nil
    recipe.results = {table.deepcopy(new_result)}
    return
end

-- Hide + disable a recipe so it won't show up / be craftable by players
function util.hide_recipe(name)
    local r = data.raw.recipe[name]
    r.hidden = true
    r.hide_from_player_crafting = true
    r.enabled = false
    return
end

return util
