data:extend({
    {
        type = "string-setting",
        name = "aai-loaders-bobs-rewrite-recipe-style",
        setting_type = "startup",
        default_value = "boblogistics",
        allowed_values = {"aai-loaders", "boblogistics"}, -- use 'mods["modname"] and "modname"' for non-dependencies/optional dependencies
        order = "a",
    },
    {
        type = "string-setting",
        name = "aai-loaders-bobs-rewrite-require-previous-tier",
        setting_type = "startup",
        default_value = "no-change",
        allowed_values = {"no-change", "force-enable", "force-disable"},
        order = "b",
    },
    {
        type = "bool-setting",
        name = "aai-loaders-bobs-rewrite-easy-mode",
        setting_type = "startup",
        default_value = false,
        order = "z",
    }
})
