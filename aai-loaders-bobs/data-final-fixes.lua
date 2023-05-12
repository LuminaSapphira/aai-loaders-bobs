-- Set Express Loader tech's packs to match adjusted logistics 3
local aai_express_tech = data.raw["technology"]["aai-express-loader"]
local logistics_3 = data.raw["technology"]["logistics-3"]
aai_express_tech.unit.ingredients = table.deepcopy(logistics_3.unit.ingredients)
aai_express_tech.unit.count = logistics_3.unit.count * 1.5
aai_express_tech.unit.time = logistics_3.unit.time * 1.5
-- Remove the production prerequisite if it's not an ingredient
if not aai_express_tech.unit.ingredients["production-science-pack"] then
    local found = -1
    for i,v in ipairs(aai_express_tech.prerequisites) do
        if v == "production-science-pack" then
            found = i
        end
    end
    if found >= 0 then
        table.remove(aai_express_tech.prerequisites, found)
    end
end

local function adjust_recipes_aai()
    if settings.startup["aai-loaders-mode"].value == "lubricated" then
        data.raw["recipe"]["aai-loader"].ingredients = {
            {"iron-plate", 4},
            {"iron-gear-wheel", 4},
            {"electronic-circuit", 5},
        }
        data.raw["recipe"]["aai-fast-loader"].ingredients = {
            {"steel-plate", 4},
            {"iron-gear-wheel", 4},
            {"electronic-circuit", 5},
        }
        data.raw["recipe"]["aai-express-loader"].ingredients = {
            {"steel-plate", 4},
            {"iron-gear-wheel", 4},
            {"advanced-circuit", 5},
        }
    else
        data.raw["recipe"]["aai-loader"].ingredients = {
            {"iron-plate", 40},
            {"iron-gear-wheel", 40},
            {"electronic-circuit", 50},
        }
        data.raw["recipe"]["aai-fast-loader"].ingredients = {
            {"steel-plate", 40},
            {"iron-gear-wheel", 40},
            {"electronic-circuit", 50},
        }
        data.raw["recipe"]["aai-express-loader"].ingredients = {
            {"steel-plate", 40},
            {"iron-gear-wheel", 40},
            {"advanced-circuit", 50},
        }
    end
end

local function adjust_recipes_easy()
    if settings.startup["aai-loaders-mode"].value == "lubricated" then
        data.raw["recipe"]["aai-loader"].ingredients = {
            {"iron-plate", 2},
            {"iron-gear-wheel", 2},
            {"electronic-circuit", 2},
            {"inserter", 2},
        }
        data.raw["recipe"]["aai-fast-loader"].ingredients = {
            {"steel-plate", 2},
            {"iron-gear-wheel", 2},
            {"electronic-circuit", 2},
        }
        if settings.startup["bobmods-logistics-inserteroverhaul"].value then
            table.insert(data.raw["recipe"]["aai-fast-loader"].ingredients, {"long-handed-inserter", 2})
        else
            table.insert(data.raw["recipe"]["aai-fast-loader"].ingredients, {"fast-inserter", 2})
        end

        data.raw["recipe"]["aai-express-loader"].ingredients = {
            {"steel-plate", 4},
            {"iron-gear-wheel", 4},
            {"advanced-circuit", 2},
        }
        if settings.startup["bobmods-logistics-inserteroverhaul"].value then
            table.insert(data.raw["recipe"]["aai-express-loader"].ingredients, {"fast-inserter", 2})
        else
            table.insert(data.raw["recipe"]["aai-express-loader"].ingredients, {"stack-inserter", 2})
        end
    else
        data.raw["recipe"]["aai-loader"].ingredients = {
            {"iron-plate", 12},
            {"iron-gear-wheel", 12},
            {"electronic-circuit", 12},
            {"inserter", 6},
        }
        data.raw["recipe"]["aai-fast-loader"].ingredients = {
            {"steel-plate", 12},
            {"iron-gear-wheel", 12},
            {"electronic-circuit", 12},
        }
        if settings.startup["bobmods-logistics-inserteroverhaul"].value then
            table.insert(data.raw["recipe"]["aai-fast-loader"].ingredients, {"long-handed-inserter", 6})
        else
            table.insert(data.raw["recipe"]["aai-fast-loader"].ingredients, {"fast-inserter", 6})
        end

        data.raw["recipe"]["aai-express-loader"].ingredients = {
            {"steel-plate", 24},
            {"iron-gear-wheel", 24},
            {"advanced-circuit", 12},
        }
        if settings.startup["bobmods-logistics-inserteroverhaul"].value then
            table.insert(data.raw["recipe"]["aai-express-loader"].ingredients, {"fast-inserter", 6})
        else
            table.insert(data.raw["recipe"]["aai-express-loader"].ingredients, {"stack-inserter", 6})
        end
    end
end

local require_previous_tier = require("utils").require_previous_tier

-- Set aai loaders to a more basic recipe, inline with bobs, if desired
if settings.startup["aai-loaders-bobs-adjust-base-loaders-recipe"].value then
    if settings.startup["aai-loaders-bobs-easy-mode"].value then
        adjust_recipes_easy()
    else
        adjust_recipes_aai()
    end
    if require_previous_tier() then
        if data.raw["item"]["aai-bob-basic-loader"] then
            table.insert(data.raw["recipe"]["aai-loader"].ingredients, {"aai-bob-basic-loader", 1})
        else
            table.insert(data.raw["recipe"]["aai-loader"].ingredients, {"transport-belt", 5})
        end
        table.insert(data.raw["recipe"]["aai-fast-loader"].ingredients, {"aai-loader", 1})
        table.insert(data.raw["recipe"]["aai-express-loader"].ingredients, {"aai-fast-loader", 1})
    else
        table.insert(data.raw["recipe"]["aai-loader"].ingredients, {"transport-belt", 1})
        table.insert(data.raw["recipe"]["aai-fast-loader"].ingredients, {"fast-transport-belt", 1})
        table.insert(data.raw["recipe"]["aai-express-loader"].ingredients, {"express-transport-belt", 1})
    end
end