local require_previous_tier = require("utils").require_previous_tier

local function make_recipes_aai_bobnew(tiers)
    if tiers["basic"] then
        tiers["basic"].recipe = {
            ingredients = {
                {"wood", 4},
                {"copper-cable", 4},
                {"iron-gear-wheel", 2},
                {"basic-transport-belt", 5},
            },
            energy_required = 1
        }
        tiers["basic"].expensive_recipe = {
            ingredients = {
                {"wood", 40},
                {"copper-cable", 40},
                {"iron-gear-wheel", 20},
                {"basic-transport-belt", 5},
            },
            energy_required = 5
        }
    end
    
    tiers["turbo"].recipe = {
        ingredients = {
            {"steel-plate", 8},
            {"iron-gear-wheel", 14},
            {"processing-unit", 5},
        },
        energy_required = 2
    }
    tiers["turbo"].expensive_recipe = {
        ingredients = {
            {"steel-plate", 80},
            {"iron-gear-wheel", 140},
            {"processing-unit", 50},
        },
        energy_required = 10
    }

    tiers["ultimate"].recipe = {
        ingredients = {
            {"steel-plate", 8},
            {"iron-gear-wheel", 14},
            {"processing-unit", 5},
        },
        energy_required = 2
    }
    tiers["ultimate"].expensive_recipe = {
        ingredients = {
            {"steel-plate", 80},
            {"iron-gear-wheel", 140},
            {"processing-unit", 50},
        },
        energy_required = 10
    }

    if require_previous_tier() then
        table.insert(tiers["turbo"].recipe.ingredients, {"aai-express-loader", 1})
        table.insert(tiers["turbo"].expensive_recipe.ingredients, {"aai-express-loader", 1})
        table.insert(tiers["ultimate"].recipe.ingredients, {"aai-bob-turbo-loader", 1})
        table.insert(tiers["ultimate"].expensive_recipe.ingredients, {"aai-bob-turbo-loader", 1})
    else
        table.insert(tiers["turbo"].recipe.ingredients, {"turbo-transport-belt", 2})
        table.insert(tiers["turbo"].expensive_recipe.ingredients, {"turbo-transport-belt", 2})
        table.insert(tiers["ultimate"].recipe.ingredients, {"ultimate-transport-belt", 2})
        table.insert(tiers["ultimate"].expensive_recipe.ingredients, {"ultimate-transport-belt", 2})
    end
end

local function make_recipes_easy_bobnew(tiers)
    if tiers["basic"] then
        tiers["basic"].recipe = {
            ingredients = {
                {"wood", 2},
                {"copper-cable", 2},
                {"iron-gear-wheel", 1},
                {"basic-transport-belt", 2},
            },
            energy_required = 1
        }
        tiers["basic"].expensive_recipe = {
            ingredients = {
                {"wood", 12},
                {"copper-cable", 12},
                {"iron-gear-wheel", 6},
                {"basic-transport-belt", 2},
            },
            energy_required = 5
        }
    end
    
    tiers["turbo"].recipe = {
        ingredients = {
            {"steel-plate", 4},
            {"iron-gear-wheel", 7},
            {"processing-unit", 2},
        },
        energy_required = 2
    }
    if settings.startup["bobmods-logistics-inserteroverhaul"].value then
        table.insert(tiers["turbo"].recipe.ingredients, {"turbo-inserter", 2})
    else
        table.insert(tiers["turbo"].recipe.ingredients, {"stack-inserter", 2})
    end

    tiers["turbo"].expensive_recipe = {
        ingredients = {
            {"steel-plate", 24},
            {"iron-gear-wheel", 42},
            {"processing-unit", 12},
        },
        energy_required = 10
    }
    if settings.startup["bobmods-logistics-inserteroverhaul"].value then
        table.insert(tiers["turbo"].expensive_recipe.ingredients, {"turbo-inserter", 6})
    else
        table.insert(tiers["turbo"].expensive_recipe.ingredients, {"stack-inserter", 6})
    end

    tiers["ultimate"].recipe = {
        ingredients = {
            {"steel-plate", 4},
            {"iron-gear-wheel", 7},
            {"processing-unit", 2},
        },
        energy_required = 2
    }
    if settings.startup["bobmods-logistics-inserteroverhaul"].value then
        table.insert(tiers["ultimate"].recipe.ingredients, {"express-inserter", 2})
    else
        table.insert(tiers["ultimate"].recipe.ingredients, {"stack-inserter", 2})
    end

    tiers["ultimate"].expensive_recipe = {
        ingredients = {
            {"steel-plate", 24},
            {"iron-gear-wheel", 42},
            {"processing-unit", 12},
        },
        energy_required = 10
    }
    if settings.startup["bobmods-logistics-inserteroverhaul"].value then
        table.insert(tiers["ultimate"].expensive_recipe.ingredients, {"express-inserter", 6})
    else
        table.insert(tiers["ultimate"].expensive_recipe.ingredients, {"stack-inserter", 6})
    end

    if require_previous_tier() then
        table.insert(tiers["turbo"].recipe.ingredients, {"aai-express-loader", 1})
        table.insert(tiers["turbo"].expensive_recipe.ingredients, {"aai-express-loader", 1})
        table.insert(tiers["ultimate"].recipe.ingredients, {"aai-bob-turbo-loader", 1})
        table.insert(tiers["ultimate"].expensive_recipe.ingredients, {"aai-bob-turbo-loader", 1})
    else
        table.insert(tiers["turbo"].recipe.ingredients, {"turbo-transport-belt", 2})
        table.insert(tiers["turbo"].expensive_recipe.ingredients, {"turbo-transport-belt", 2})
        table.insert(tiers["ultimate"].recipe.ingredients, {"ultimate-transport-belt", 2})
        table.insert(tiers["ultimate"].expensive_recipe.ingredients, {"ultimate-transport-belt", 2})
    end
end


local function make_recipes_aai(tiers)
    make_recipes_aai_bobnew(tiers)
end

local function make_recipes_easy(tiers)
    make_recipes_easy_bobnew(tiers)
end

local function make_recipes(tiers)
    if settings.startup["aai-loaders-bobs-easy-mode"].value then
        make_recipes_easy(tiers)
    else
        make_recipes_aai(tiers)
    end
end

return make_recipes