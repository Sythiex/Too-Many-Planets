if not mods["Quality-Plus-Plus"]
    or not mods["Paracelsin"]
    or not mods["secretas"]
    or not mods["skewer_planet_vesta"]
    or settings.startup["tmp-quality-plus-plus-integration"].value ~= true
then
    return
end

local util = require("util")

-- Move legendary quality to Paracelsin.
util.remove_tech_prereq("legendary-quality", "cryogenic-science-pack")
util.remove_tech_ingredient("legendary-quality", "cryogenic-science-pack")

if mods["outer-rim"] then
    util.remove_tech_prereq("legendary-quality", "outer-rim-cryochemical-science-pack")
    util.remove_tech_ingredient("legendary-quality", "outer-rim-cryochemical-science-pack")
end

util.add_tech_prereq("legendary-quality", "galvanization-science-pack")

-- Map each added quality to its new technology.
local QUALITY_TECHNOLOGIES = {
    {
        quality = "mythical",
        technology = "tmp-mythical-quality",
        research_count = 6000,
        prerequisites = {
            "cryogenic-science-pack",
        },
        science_packs = {
            "cryogenic-science-pack",
        },
    },
    {
        quality = "masterwork",
        technology = "tmp-masterwork-quality",
        research_count = 7000,
        prerequisites = {
            "golden-science-pack",
        },
        science_packs = {
            "cryogenic-science-pack",
            "golden-science-pack",
        },
    },
    {
        quality = "wondrous",
        technology = "tmp-wondrous-quality",
        research_count = 8000,
        prerequisites = {
            "s1_gas_manipulation_science_pack",
        },
        science_packs = {
            "cryogenic-science-pack",
            "golden-science-pack",
            "gas-manipulation-science-pack",
        },
    },
    {
        quality = "artifactual",
        technology = "tmp-artifactual-quality",
        research_count = 9000,
        prerequisites = {
            "promethium-science-pack",
        },
        science_packs = {
            "cryogenic-science-pack",
            "golden-science-pack",
            "gas-manipulation-science-pack",
            "promethium-science-pack",
        },
    },
}

-- Validate the technology used as the template and start of the new chain.
local legendary_technology = data.raw.technology["legendary-quality"]
if not legendary_technology then
    error("Too Many Planets: cannot split Quality++ quality technologies: technology 'legendary-quality' does not exist")
end

-- Increase the research cycles required for each successive quality tier.
legendary_technology.unit.count = 5000
legendary_technology.unit.count_formula = nil

-- Remove Quality++ unlocks from legendary quality while preserving unrelated effects.
local managed_qualities = {}
for _, definition in ipairs(QUALITY_TECHNOLOGIES) do
    managed_qualities[definition.quality] = true
end

for index = #(legendary_technology.effects or {}), 1, -1 do
    local effect = legendary_technology.effects[index]
    if effect.type == "unlock-quality" and managed_qualities[effect.quality] then
        table.remove(legendary_technology.effects, index)
    end
end

-- Create one sequential technology for each enabled Quality++ quality.
local previous_technology = "legendary-quality"
for _, definition in ipairs(QUALITY_TECHNOLOGIES) do
    local quality = data.raw.quality[definition.quality]
    if quality and quality.hidden ~= true then
        local technology = table.deepcopy(legendary_technology)
        technology.name = definition.technology
        technology.localised_name = nil
        technology.localised_description = nil
        technology.unit.count = definition.research_count
        technology.unit.count_formula = nil
        technology.effects = {
            {
                type = "unlock-quality",
                quality = definition.quality,
            },
        }
        technology.prerequisites = {previous_technology}
        technology.icons = nil
        technology.icon = quality.icon
        technology.icon_size = quality.icon_size or 64

        data:extend({technology})
        for _, prerequisite in ipairs(definition.prerequisites or {}) do
            util.add_tech_prereq(definition.technology, prerequisite)
        end

        for _, science_pack in ipairs(definition.science_packs or {}) do
            util.add_tech_ingredient(definition.technology, science_pack, 1)
        end

        previous_technology = definition.technology
    end
end
