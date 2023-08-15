local dummy = {}
dummy.mods = {}
dummy.mods.boblogistics = {
    basic = {"logistics-0"},
    regular = {"logistics", "aai-boblogistics-basic-loader"},
    fast = {"logistics-2", "aai-boblogistics-loader"},
    express = {"logistics-3", "aai-boblogistics-fast-loader"},
    turbo = {"logistics-4", "aai-boblogistics-express-loader"},
    ultimate = {"logistics-5", "aai-boblogistics-turbo-loader"}
}
dummy.fluids = {}
dummy.fluids.boblogistics = {
    express = {"lubricant"}
}

local earlyLube = false
for _, effect in pairs(data.raw.technology["oil-processing"].effects) do
    if effect.recipe == "lubricant-from-crude-oil" then
        earlyLube = true
    end
end

if earlyLube then
    dummy.fluids.boblogistics.fast = {}
    if mods["angelspetrochem"] then -- angels replaces the oil processing recipe.
        table.insert(
            data.raw.technology["angels-oil-processing"].effects, 
            {type="unlock-recipe", recipe="lubricant-from-crude-oil"} -- add the early lube recipe
        )
        table.insert(dummy.fluids.boblogistics.fast, "angels-oil-processing")
    else
        table.insert(dummy.fluids.boblogistics.fast, "oil-processing")
    end
end

local function inserters() -- add prereqs when recipes need inserters
    if settings.startup["bobmods-logistics-inserteroverhaul"].value then
        table.insert(dummy.mods.boblogistics.fast, "stack-inserter")
        table.insert(dummy.mods.boblogistics.express, "stack-inserter-2")
        table.insert(dummy.mods.boblogistics.turbo, "stack-inserter-3")
        table.insert(dummy.mods.boblogistics.ultimate, "stack-inserter-4")
    else
        table.insert(dummy.mods.boblogistics.fast, "fast-inserter")
        table.insert(dummy.mods.boblogistics.express, "stack-inserter")
        table.insert(dummy.mods.boblogistics.turbo, "stack-inserter-2")
        table.insert(dummy.mods.boblogistics.ultimate, "stack-inserter-2")
    end
end

local function intermediates() -- add prereqs when recipes need intermediates
    if mods["bobplates"] and settings.startup["bobmods-logistics-robotparts"] then
        -- No fast prereq; add logistic robot tool 1 to unlocks for fast loaders to keep progression on-par across the board
        table.insert(dummy.mods.boblogistics.express, "bob-robots-1")
        table.insert(dummy.mods.boblogistics.turbo, "bob-robots-2")
        table.insert(dummy.mods.boblogistics.ultimate, "bob-robots-3")
    else
        table.insert(dummy.mods.boblogistics.fast, "engine")
        table.insert(dummy.mods.boblogistics.express, "electric-engine")
        -- no need to include advanced-electronics at turbo tier because logistics 4 has that prereq
        table.insert(dummy.mods.boblogistics.ultimate, "low-density-structure")
    end
end

if settings.startup["aai-loaders-bobs-rewrite-recipe-style"].value == "aai-loaders" then
    intermediates()
end

if settings.startup["aai-loaders-bobs-rewrite-recipe-style"].value == "boblogistics" then
    inserters()
    -- no need to add plates prereqs, because plate requirements are pulled from the appropriate logistics tech.
end

return dummy