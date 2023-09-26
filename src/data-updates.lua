local utils = require("utils")
local resourceTiers = require("resource-tiers")
local techRequirements = require("technology-requirements")

local beltTiers = { -- List of tiers that are present for one or more given mods. beltTiers[mod][tier] will be nil if the belt tier doesn't exist.
    boblogistics = {
        basic = data.raw["transport-belt"]["basic-transport-belt"] and 0, -- index if the belt exists, nil if not 
        regular = 1, -- basegame belts
        fast = 2,
        express = 3,
        turbo = data.raw["transport-belt"]["turbo-transport-belt"] and 4,
        ultimate = data.raw["transport-belt"]["ultimate-transport-belt"] and 5
    }
}
local tierColors = {
    boblogistics = { -- defaults from AAILoaders and Bob's Logistics
        basic = util.color("7d7d7dff"),
        regular = {255, 217, 85},
        fast = {255, 24, 38},
        express = {90, 190, 255},
        turbo = util.color("a510e5ff"),
        ultimate = util.color("16f263ff")
    }
}

if mods["boblogistics-belt-reskin"] then
    if data.raw["transport-belt"]["basic-transport-belt"] then
        tierColors.boblogistics.basic = util.color("e7e7e7d1")
    end
    if data.raw["transport-belt"]["turbo-transport-belt"] then
        tierColors.boblogistics.turbo = util.color("df1ee5d1")
    end
end

if mods["reskins-library"] and not (reskins.bobs and (reskins.bobs.triggers.logistics.entities == false)) then
    tierColors.boblogistics.basic = reskins.lib.belt_tint_index[0]
    tierColors.boblogistics.regular = reskins.lib.belt_tint_index[1]
    tierColors.boblogistics.fast = reskins.lib.belt_tint_index[2]
    tierColors.boblogistics.express = reskins.lib.belt_tint_index[3]
    tierColors.boblogistics.turbo = reskins.lib.belt_tint_index[4]
    tierColors.boblogistics.ultimate = reskins.lib.belt_tint_index[5]
end

local migrations = { -- this is a list of scripts to run in the migrations folder. Should be true whenever the associated mod is present, and nil otherwise. 
    ["aai-loaders"] = true -- dependency, always true
}

local earlyLube = false -- probably going to stay false, but just in case...
for _, effect in pairs(data.raw.technology["oil-processing"].effects) do
    if effect.recipe == "lubricant-from-crude-oil" then
        earlyLube = true
    end
end

for name, _ in pairs(data.raw["loader-1x1"]) do
    if name:match("aai%-.*loader") then
        data.raw["loader-1x1"][name] = nil
        data.raw["storage-tank"][name .. "-pipe"] = nil
        data.raw["item"][name] = nil
        data.raw["recipe"][name] = nil
        data.raw["technology"][name] = nil
    end
end
AAILoaders.loader_count = 0 -- yeet all the AAI loaders to prevent redundancies

for mod, _ in pairs(mods) do -- don't care what version atm
    local lastTier = nil
    if beltTiers[mod] then
        for tier, index in pairs(beltTiers[mod]) do -- if it doesn't exist, it won't be found by pairs bc it'd be an element set to nil (and thus deleted)
            local fluidToUse = "lubricant"
            if ((earlyLube and 1 or 0) + index) < 3 then
                fluidToUse = "water"
            end
            local techUnit
            if index == 1 then
                techUnit = table.deepcopy(data.raw.technology["logistics"].unit)
            else
                techUnit = table.deepcopy(data.raw.technology["logistics-" .. index].unit)
            end
            techUnit.count = math.floor(techUnit.count * 1.5)
            local recipeType = "crafting"
            local loaderIngredients = utils.get_ingredients(tier, mod)
            for _, ingredient in pairs(loaderIngredients) do
                if ingredient.type == "fluid" then
                    recipeType = "crafting-with-fluid"
                end
            end
            local loaderRecipe = {
                crafting_category = recipeType,
                ingredients = loaderIngredients,
                energy_required = 2
            }
            local expensiveRecipe = table.deepcopy(loaderRecipe)
            for i, ingredient in pairs(expensiveRecipe.ingredients) do
                for j, elem in pairs(ingredient) do
                    if type(elem) == "number" then
                        expensiveRecipe.ingredients[i][j] = expensiveRecipe.ingredients[i][j] * 10
                    end
                end
            end
            if utils.require_previous_tier() and lastTier then
                table.insert(loaderRecipe.ingredients, {"aai-" .. mod .. ((lastTier ~= "regular") and ("-" .. lastTier) or "") .. "-loader", 1})
                table.insert(expensiveRecipe.ingredients, {"aai-" .. mod .. ((lastTier ~= "regular") and ("-" .. lastTier) or "") .. "-loader", 1})
            end

            AAILoaders.make_tier{
                name = mod .. ((tier ~= "regular") and ("-" .. tier) or ""),
                transport_belt = ((tier ~= "regular") and (tier .. "-") or "") .. "transport-belt",
                color = tierColors[mod][tier],
                fluid = fluidToUse,
                fluid_per_minute = math.floor(((fluidToUse == "water") and (20 * index + 20) or (.05 * index + .05)) * 20) / 20,
                fluid_technology_prerequisites = techRequirements.fluids[mod][tier],
                technology = {
                    prerequisites = techRequirements.mods[mod][tier],
                    unit = techUnit
                },
                recipe = loaderRecipe,
                unlubricated_recipe = settings.startup["aai-loaders-bobs-rewrite-easy-mode"].value and loaderRecipe or expensiveRecipe,
                order = "d[loader]-a0" .. index .. "[aai-" .. mod .. ((tier ~= "regular") and ("-" .. tier) or "") .. "-loader]",
                localise = true
            }

            local loaderName = "aai-" .. mod .. ((tier ~= "regular") and ("-" .. tier) or "") .. "-loader"

            local prototypes = {
                loader = data.raw["loader-1x1"][loaderName],
                item = data.raw["item"][loaderName],
                recipe = data.raw["recipe"][loaderName],
                technology = data.raw["technology"][loaderName]
            }

            if mods["reskins-library"] then
                reskins.lib.append_tier_labels(index, {icon = prototypes.item.icons, tier_labels = true})
            end
            if mod == "boblogistics" then
                prototypes.recipe.subgroup = "bob-logistic-tier-" .. index
                prototypes.item.subgroup = "bob-logistic-tier-" .. index
            end
            lastTier = tier
        end
    end
end
