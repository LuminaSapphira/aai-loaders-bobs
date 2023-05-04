function require_previous_tier()
    if settings.startup["aai-loaders-bobs-require-previous-tier"].value == "no-change" then
        return settings.startup["bobmods-logistics-beltrequireprevious"].value
    else
        return settings.startup["aai-loaders-bobs-require-previous-tier"].value == "force-enable"
    end
end
