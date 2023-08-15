local dummy = {}
dummy.resourceTiers = {}

local resourceTiersTemplate = {
    belt = {},
    circuit = {},
    gear = {},
    inserter = {},
    intermediate = {},
    plate = {}
}

-- bobslogistics
do
    local resourceTiers = table.deepcopy(resourceTiersTemplate)

    -- Belts
    do
        local belt = resourceTiers.belt
        -- base
        belt.basic = {{"basic-transport-belt", 1}}
        belt.regular = {{"transport-belt", 1}}
        belt.fast = {{"fast-transport-belt", 1}}
        belt.express = {{"express-transport-belt", 1}}
        belt.turbo = {{"turbo-transport-belt", 1}}
        belt.ultimate = {{"ultimate-transport-belt", 1}}
    end

    -- Circuits
    do
        local circuit = resourceTiers.circuit
        -- base
        circuit.basic = {{"copper-cable", .8}, {"wood", .8}} -- all these values will get rounded when they are used
        circuit.regular = {{"electronic-circuit", 1}}
        circuit.fast = {{"electronic-circuit", 1}}
        circuit.express = {{"advanced-circuit", 1}}
        circuit.turbo = {{"processing-unit", 1}}
        circuit.ultimate = {{"processing-unit", 1}}

        if mods["bobelectronics"] or mods["bobplates"] then -- redundant recipes, apparently!
            circuit.ultimate = {{"advanced-processing-unit", 1}}
        end
        if mods["CircuitProcessing"] then
            circuit.regular = {{"basic-circuit-board", 1}}
        end
        if mods["SeaBlock"] then
            circuit.basic = {{"copper-cable", .8}} -- remove wood, bc that's not available at the start of seablock; seablock does a matching change to splitters
        end
    end

    -- Gears
    do
        local gear = resourceTiers.gear
        -- base
        gear.basic = {{"iron-gear-wheel", 1}}
        gear.regular = table.deepcopy(gear.basic) -- everything uses iron gear if no Bob's MCI
        gear.fast = table.deepcopy(gear.basic)
        gear.express = table.deepcopy(gear.basic)
        gear.turbo = table.deepcopy(gear.basic)
        gear.ultimate = table.deepcopy(gear.basic)
        
        if mods["bobplates"] then -- MCI
            gear.fast = {{"steel-gear-wheel", 1}}
            gear.express = {{"cobalt-steel-gear-wheel", 1}, {"cobalt-steel-bearing", 1}}
            gear.turbo = {{"titanium-gear-wheel", 1}, {"titanium-bearing", 1}}
            gear.ultimate = {{"nitinol-gear-wheel", 1}, {"nitinol-bearing", 1}}
        end
    end

    -- Inserters
    do
        local inserter = resourceTiers.inserter
        -- base
        inserter.basic = {{"iron-gear-wheel", 1}, {"iron-plate", 1}} -- don't force people to make burner inserters like an evil person
        inserter.regular = {{"inserter", 1}}
        if settings.startup["bobmods-logistics-inserteroverhaul"].value then -- tiered inserters!
            inserter.fast = {{"red-stack-inserter", .5}} -- all these values will get rounded when they are used
            inserter.express = {{"stack-inserter", .5}}
            inserter.turbo = {{"turbo-stack-inserter", .5}}
            inserter.ultimate = {{"express-stack-inserter", .5}} -- why the hell does bobslogistics name their ultimate stack inserter like this
        else -- booooooring. ./s
            inserter.fast = {{"fast-inserter", 1}}
            inserter.express = {{"stack-inserter", .5}}
            inserter.turbo = {{"express-stack-inserter", .5}}
            inserter.ultimate = {{"express-stack-inserter", .5}}
        end
        -- shouldn't need anything below this, as boblogistics does the inserters, but just in case, I'm leaving placeholder space for other mod tweaks

    end

    -- Intermediates
    do
        local intermediate = resourceTiers.intermediate
        -- base
        intermediate.basic = {{"iron-gear-wheel", 1}}
        intermediate.regular = {{"iron-gear-wheel", 2}}
        intermediate.fast = {{"engine-unit", 1}}
        intermediate.express = {{"electric-engine-unit", 1}, {type = "fluid", name = "lubricant", amount = 10}}
        intermediate.turbo = {{"electric-engine-unit", 1}, {"advanced-circuit", 1}, {type = "fluid", name = "lubricant", amount = 15}}
        intermediate.ultimate = {{"electric-engine-unit", 1}, {"advanced-circuit", 1}, {"low-density-structure", 1}, {type = "fluid", name = "lubricant", amount = 20}}
        
        if mods["bobplates"] and settings.startup["bobmods-logistics-robotparts"] then
            -- logistics tools map to the material tiers much more nicely than the above when MCI is present. These will be added to the loader techs, to be safe.
            intermediate.fast = {{"robot-tool-logistic", 1}}
            intermediate.express = {{"robot-tool-logistic-2", 1}, {type = "fluid", name = "lubricant", amount = 10}}
            intermediate.turbo = {{"robot-tool-logistic-3", 1}, {type = "fluid", name = "lubricant", amount = 15}}
            intermediate.ultimate = {{"robot-tool-logistic-4", 1}, {type = "fluid", name = "lubricant", amount = 20}}
        end
    end

    -- Plates
    do
        local plate = resourceTiers.plate
        -- base
        plate.basic = {{"iron-plate", 1}}
        plate.regular = {{"iron-plate", 1}}
        plate.fast = {{"steel-plate", 1}}
        plate.express = table.deepcopy(plate.fast)
        plate.turbo =  table.deepcopy(plate.fast)
        plate.ultimate = table.deepcopy(plate.fast)

        if mods["bobplates"] then
            plate.regular = {{"tin-plate", 1}}
            plate.fast = {{"bronze-alloy", 1}}
            plate.express = {{"aluminium-plate", 1}}
            plate.turbo = {{"titanium-plate", 1}}
            plate.ultimate = {{"nitinol-alloy", 1}}
        end
    end
    dummy.resourceTiers.boblogistics = resourceTiers
end

return dummy.resourceTiers