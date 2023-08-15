local function require_previous_tier()
    if settings.startup["aai-loaders-bobs-rewrite-require-previous-tier"].value == "no-change" then
        return settings.startup["bobmods-logistics-beltrequireprevious"].value
    else
        return settings.startup["aai-loaders-bobs-rewrite-require-previous-tier"].value == "force-enable"
    end
end

local resourceTiers = require("resource-tiers")

local function get_ingredients(tier, mod)
    local recipeStyles = {
        ["aai-loaders"] = {
            {
                type = "circuit",
                amount = 5
            },
            {
                type = "intermediate",
                amount = 5
            },
            {
                type = "belt",
                amount = 1
            }
        },
        ["boblogistics"] = {
            {
                type = "circuit",
                amount = 5
            },
            {
                type = "inserter",
                amount = 4
            },
            {
                type = "plate",
                amount = 4
            },
            {
                type = "belt",
                amount = 5
            }
        }
    }
    local recipeStyle = recipeStyles[settings.startup["aai-loaders-bobs-rewrite-recipe-style"].value]
    local ingredients = {}
    for _, placeholder in pairs(recipeStyle) do
        for _, ingredient in pairs(resourceTiers[mod][placeholder.type][tier]) do
            local temp = table.deepcopy(ingredient)
            for index, element in pairs(temp) do
                if type(element) == "number" then
                    temp[index] = math.floor(temp[index] * placeholder.amount) -- round partial costs down
                end
            end
            table.insert(ingredients, temp)
        end
    end
    return ingredients
end

return {
    require_previous_tier = require_previous_tier,
    get_ingredients = get_ingredients
}

