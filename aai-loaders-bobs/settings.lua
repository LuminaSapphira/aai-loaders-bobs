data:extend({
    {
        type = "bool-setting",
        name = "aai-loaders-bobs-adjust-base-loaders-recipe",
        setting_type = "startup",
        default_value = true,
        order = "a",
    },
    {
        type = "string-setting",
        name = "aai-loaders-bobs-require-previous-tier",
        setting_type = "startup",
        default_value = "no-change",
        allowed_values = {"no-change", "force-enable", "force-disable"},
        order = "b",
    },
    {
        type = "bool-setting",
        name = "aai-loaders-bobs-easy-mode",
        setting_type = "startup",
        default_value = false,
        order = "z",
    }
})
