local util = {}

local function require_technology(name, role, operation)
    local tech = data.raw.technology[name]
    if tech then
        return tech
    end

    local message = ("Too Many Planets: cannot %s: %s technology '%s' does not exist"):format(operation, role, name)
    error(message, 3)
end

local function require_recipe(name, operation)
    local recipe = data.raw.recipe[name]
    if recipe then
        return recipe
    end

    local message = ("Too Many Planets: cannot %s: target recipe '%s' does not exist"):format(operation, name)
    error(message, 3)
end

local function require_science_pack(name, operation)
    local tool = data.raw.tool[name]
    if tool then
        return tool
    end

    local message = ("Too Many Planets: cannot %s: science pack '%s' does not exist"):format(operation, name)
    error(message, 3)
end

-- Adds prereq_name to tech_name.prerequisites (if not already present)
function util.add_tech_prereq(tech_name, prereq_name)
    local operation = ("add prerequisite '%s' to technology '%s'"):format(prereq_name, tech_name)
    local tech = require_technology(tech_name, "target", operation)
    require_technology(prereq_name, "prerequisite", operation)
    tech.prerequisites = tech.prerequisites or {}

    for _, name in ipairs(tech.prerequisites) do
        if name == prereq_name then
            return true -- already present
        end
    end

    table.insert(tech.prerequisites, prereq_name)
    return true
end

-- Removes prereq_name from tech_name.prerequisites
function util.remove_tech_prereq(tech_name, prereq_name)
    local operation = ("remove prerequisite '%s' from technology '%s'"):format(prereq_name, tech_name)
    local tech = require_technology(tech_name, "target", operation)
    require_technology(prereq_name, "prerequisite", operation)

    if not tech.prerequisites then
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

-- Adds ingredient_name to tech_name.unit.ingredients (if not already present)
function util.add_tech_ingredient(tech_name, ingredient_name, amount)
    local operation = ("add science pack '%s' to technology '%s'"):format(ingredient_name, tech_name)
    local tech = require_technology(tech_name, "target", operation)
    require_science_pack(ingredient_name, operation)

    if not tech.unit then
        local message = ("Too Many Planets: cannot %s: target technology '%s' does not have a research unit"):format(operation, tech_name)
        error(message, 2)
    end

    tech.unit.ingredients = tech.unit.ingredients or {}

    for _, ingredient in ipairs(tech.unit.ingredients) do
        if (ingredient.name or ingredient[1]) == ingredient_name then
            return true -- already present
        end
    end

    table.insert(tech.unit.ingredients, {ingredient_name, amount or 1})
    return true
end

function util.unlock_recipe(recipe)
    return {
        type = "unlock-recipe",
        recipe = recipe
    }
end

function util.clear_research_trigger(name)
    local operation = ("clear research trigger from technology '%s'"):format(name)
    local tech = require_technology(name, "target", operation)
    tech.research_trigger = nil
end

function util.set_tech_trigger_item(tech_name, item_filter, count)
    local operation = ("set item research trigger '%s' on technology '%s'"):format(item_filter, tech_name)
    local t = require_technology(tech_name, "target", operation)
    t.research_trigger = {
        type = "craft-item",
        item = item_filter,
        count = count or 1
    }
    t.unit = nil
    return
end

function util.set_tech_trigger_fluid(tech_name, fluid)
    local operation = ("set fluid research trigger '%s' on technology '%s'"):format(fluid, tech_name)
    local t = require_technology(tech_name, "target", operation)
    t.research_trigger = {
        type = "craft-fluid",
        fluid = fluid
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
    local operation = ("set research unit on technology '%s'"):format(tech_name)
    local tech = require_technology(tech_name, "target", operation)
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
    local operation = ("modify recipe '%s'"):format(name)
    local r = require_recipe(name, operation)
    r.energy_required = energy_required
    r.ingredients = ingredients
end

function util.set_recipe_result(recipe_name, result_name, amount, result_type)
    local operation = ("set result '%s' on recipe '%s'"):format(result_name, recipe_name)
    local recipe = require_recipe(recipe_name, operation)

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
    local operation = ("hide recipe '%s'"):format(name)
    local r = require_recipe(name, operation)
    r.hidden = true
    r.hide_from_player_crafting = true
    r.enabled = false
    return
end

return util
