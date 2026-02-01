local util = {}

-- Adds prereq_name to tech_name.prerequisites (if both techs exist, and not already present)
function util.add_tech_prereq(tech_name, prereq_name)
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
function util.remove_tech_prereq(tech_name, prereq_name)
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

function util.unlock_recipe(recipe)
    return {
        type = "unlock-recipe",
        recipe = recipe
    }
end

function util.clear_research_trigger(name)
    local t = data.raw.technology[name]
    if t then t.research_trigger = nil end
end

function util.upsert_technology(proto)
    local existing = data.raw.technology[proto.name]
    if existing then
        for k, v in pairs(proto) do existing[k] = v end
    else
        data:extend({proto})
    end
end

--   - tech_name: Technology prototype name (string)
--   - count: Total number of research cycles (integer) (optional)
--   - ingredients: Science packs required per cycle (table) (optional)
--   - time: Seconds per cycle (number) (optional)
function util.set_tech_unit(tech_name, count, ingredients, time)
    local tech = data.raw.technology[tech_name]
    if not tech then return false end

    tech.unit = tech.unit or {}

    tech.unit.count_formula = nil

    if count ~= nil then tech.unit.count = count end
    if ingredients ~= nil then tech.unit.ingredients = ingredients end
    if time ~= nil then tech.unit.time = time end

    return true
end

function util.set_recipe(name, energy_required, ingredients)
    local r = data.raw.recipe[name]
    if not r then return end
    r.energy_required = energy_required
    r.ingredients = ingredients
end

function util.set_craft_item_trigger(tech_name, item_filter, count)
    local t = data.raw.technology[tech_name]
    if not t then return false end
    t.research_trigger = {
        type = "craft-item",
        item = item_filter,
        count = count or 1
    }
    t.unit = nil
    return true
end

-- Hide + disable a recipe so it won't show up / be craftable by players
function util.hide_recipe(name)
    local r = data.raw.recipe[name]
    if not r then return false end

    r.hidden = true
    r.hide_from_player_crafting = true
    r.enabled = false
    return true
end

-- Replace all "unlock-recipe old_recipe" effects with "unlock-recipe new_recipe"
function util.swap_recipe_unlocks(old_recipe, new_recipe)
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then for _, eff in ipairs(tech.effects) do if eff.type == "unlock-recipe" and eff.recipe == old_recipe then eff.recipe = new_recipe end end end
    end
end

-- If you are Talandar99 please let me make my pack in peace.
-- Create a new recipe cloned from base_name, overwrite energy/ingredients,
-- swap tech unlocks from base->new, then hide/disable the base recipe.
function util.create_replacement_recipe(base_name, new_name, energy_required, ingredients)
    local base = data.raw.recipe[base_name]
    if not base then
        log(("create_replacement_recipe: base recipe not found: %s"):format(base_name))
        return false
    end
    if data.raw.recipe[new_name] then return true end

    local r = table.deepcopy(base)
    r.name = new_name
    r.localised_name = base.localised_name and table.deepcopy(base.localised_name) or {"entity-name." .. base_name}
    if base.localised_description then r.localised_description = table.deepcopy(base.localised_description) end
    r.enabled = false
    r.hidden = false
    r.hide_from_player_crafting = false

    local function apply(tbl)
        if energy_required ~= nil then tbl.energy_required = energy_required end
        if ingredients ~= nil then tbl.ingredients = ingredients end
    end

    -- Support both recipe styles: single table OR normal/expensive
    if r.normal or r.expensive then
        if r.normal then apply(r.normal) end
        if r.expensive then apply(r.expensive) end
    else
        apply(r)
    end

    data:extend({r})

    util.swap_recipe_unlocks(base_name, new_name)
    util.hide_recipe(base_name)

    return true
end

return util
