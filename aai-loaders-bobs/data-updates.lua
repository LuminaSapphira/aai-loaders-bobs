local tiers = {
    ["basic"] = { color = util.color("7d7d7dd1"), fluid = "water", lubricant_running = 20, index = 0, previous_loader = nil, logistics = "logistics-0" },
    ["turbo"] = { color = util.color("a510e5d1"), fluid = "lubricant", lubricant_running = 0.25, index = 4, previous_loader = "aai-express-loader", logistics = "logistics-4" },
    ["ultimate"] = { color = util.color("16f263d1"), fluid = "lubricant", lubricant_running = 0.3, index = 5, previous_loader = "aai-bobs-turbo-loader", logistics = "logistics-5" },
}

if not data.raw["transport-belt"]["basic-transport-belt"] then
    tiers["basic"] = nil
end

for k,v in pairs(tiers) do
    v.technology = {
        name = "aai-bobs-" .. k .. "-loader",
        prerequisites = { v.logistics, v.previous_loader },
        unit = {
            count = data.raw["technology"][v.logistics].unit.count * 1.5,
            ingredients = table.deepcopy(data.raw["technology"][v.logistics].unit.ingredients),
            time = data.raw["technology"][v.logistics].unit.time * 1.5
        }
    }
end

require("recipes")(tiers)

if mods["boblogistics-belt-reskin"] then
    if data.raw["transport-belt"]["basic-transport-belt"] then
        tiers["basic"].color = util.color("e7e7e7d1")
    end
    tiers["turbo"].color = util.color("df1ee5d1")
end

if mods["reskins-library"] and not (reskins.bobs and (reskins.bobs.triggers.logistics.entities == false)) then
    if data.raw["transport-belt"]["basic-transport-belt"] then
        tiers["basic"].color = reskins.lib.belt_tint_index[tiers["basic"].index]
    end
    tiers["turbo"].color = reskins.lib.belt_tint_index[tiers["turbo"].index]
    tiers["ultimate"].color = reskins.lib.belt_tint_index[tiers["ultimate"].index]
end

local function make_tier(key)

    AAILoaders.make_tier({
        name = "bob-" .. key,
        transport_belt = key .. "-transport-belt",
        color = tiers[key]["color"],
        fluid = tiers[key].fluid,
        fluid_per_minute = tiers[key]["lubricant_running"],
        technology = tiers[key]["technology"],
        recipe = tiers[key].recipe,
        unlubricated_recipe = tiers[key].expensive_recipe,
        order = "d[loader]-a0" .. tiers[key]["index"] .. "[aai-bob-" .. key .. "-loader]",
        localise = true
    })

    data.raw["recipe"]["aai-bob-" .. key .. "-loader"].subgroup = "bob-logistic-tier-" .. tiers[key].index
    data.raw["item"]["aai-bob-" .. key .. "-loader"].subgroup = "bob-logistic-tier-" .. tiers[key].index

end

for k,v in pairs(tiers) do
    make_tier(k)
    if mods["reskins-library"] then
        reskins.lib.append_tier_labels(v.index, { icon = data.raw["item"]["aai-bob-" .. k .. "-loader"].icons, tier_labels = true })
    end
end

if mods["reskins-library"] then
    reskins.lib.append_tier_labels(1, { icon = data.raw["item"]["aai-loader"].icons, tier_labels = true })
    reskins.lib.append_tier_labels(2, { icon = data.raw["item"]["aai-fast-loader"].icons, tier_labels = true })
    reskins.lib.append_tier_labels(3, { icon = data.raw["item"]["aai-express-loader"].icons, tier_labels = true })
end

data.raw["recipe"]["aai-loader"].subgroup = "bob-logistic-tier-1"
data.raw["recipe"]["aai-fast-loader"].subgroup = "bob-logistic-tier-2"
data.raw["recipe"]["aai-express-loader"].subgroup = "bob-logistic-tier-3"
data.raw["item"]["aai-loader"].subgroup = "bob-logistic-tier-1"
data.raw["item"]["aai-fast-loader"].subgroup = "bob-logistic-tier-2"
data.raw["item"]["aai-express-loader"].subgroup = "bob-logistic-tier-3"
