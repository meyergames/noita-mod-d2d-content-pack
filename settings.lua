dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "D2DContentPack" -- This should match the name of your mod's folder.
mod_settings_version = 1      -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
    -- {
    --     category_id = "default_settings",
    --     ui_name = "",
    --     ui_description = "",
    --     settings = {
    --         {
    --             id = "enable_curses",
    --             ui_name = "Enable curses",
    --             ui_description = "Curses are perks with negative effects, designed\nas a way to balance certain powerful effects.",
    --             value_default = true,
    --             scope = MOD_SETTING_SCOPE_NEW_GAME,
    --         },
    --     }
    -- },
    {
        category_id = "default_settings",
        ui_name = "",
        ui_description = "",
        settings = {
            {
                id = "afa_compat",
                ui_name = "Disable alt fire spells if Alt Fire Anything is enabled",
                ui_description = "If the Alt Fire Anything mod is enabled, disable this\nmod's individual alt fire spell variations.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "spawn_time_trial_at_start",
                ui_name = "Sometimes spawn Time Trial at start",
                ui_description = "When enabled, there's a 5% chance for a copy of the\nTime Trial perk to spawn at the mountain entrance.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        },
    },
}

function ModSettingsUpdate(init_scope)
    local old_version = mod_settings_get_version(mod_id)
    mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
    return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
    mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
