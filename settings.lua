dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "D2DContentPack" -- This should match the name of your mod's folder.
mod_settings_version = 1      -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
    {
        category_id = "default_settings",
        ui_name = "General",
        ui_description = "",
        settings = {
            {
                id = "enable_repeating_update_messages",
                ui_name = "Repeat in-game messages about new updates",
                ui_description = "When this setting is enabled, in-game messages about\nnew updates to this mod will be shown once per run.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        }
    },
    {
        category_id = "perk_settings",
        ui_name = "Perks",
        ui_description = "",
        settings = {
            {
                id = "always_spawn_mod_reworks",
                ui_name = "Always spawn mod reworks",
                ui_description = "When enabled, reworks for perks from other mods can spawn\neven if the original mod is not enabled.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "spawn_challenge_perk_sometimes",
                ui_name = "Sometimes spawn a Challenge Perk on new game start",
                ui_description = "When you start a new game with this setting enabled, there's\na 5% chance for Time Trial or Glass Heart to spawn at the\nmountain entrance.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
        },
    },
    {
        category_id = "item_settings",
        ui_name = "Items",
        ui_description = "",
        settings = {
            {
                id = "auto_emergency_injection_threshold",
                ui_name = "Emergency Injection auto-use threshold",
                ui_description = "When you have an Emergency Injection in your inventory,\nit will automatically be used below this percentage of your\nmax HP. A value of 0 disables this functionality.",
                value_default = 0.05,
                value_min = 0,
                value_max = 0.2,
                value_display_multiplier = 100,
                value_display_formatting = " $0 %",
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
            -- {
            --     id = "auto_pickup_hammer",
            --     ui_name = "Auto pickup Hammer",
            --     ui_description = "Whether to automatically pick up the Hammer item.",
            --     value_default = true,
            --     scope = MOD_SETTING_SCOPE_RESTART,
            -- },
        },
    },
    {
        category_id = "spell_settings",
        ui_name = "Spells",
        ui_description = "",
        settings = {
            {
                id = "more_starting_wand_variety",
                ui_name = "More starting wand variety",
                ui_description = "When enabled, your starting wand may contain a wider\nvariety of the base game's projectile spells.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "dynamite_as_default_bomb",
                ui_name = "Start with dynamite more often",
                ui_description = "When enabled, your starting bomb wand has a higher chance\nto contain dynamite.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "sometimes_start_with_glass_shard",
                ui_name = "Sometimes start with Glass Shard",
                ui_description = "When enabled, your starting wand may sometimes contain\nthe Glass Shard spell.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "sometimes_start_with_sniper_bolt",
                ui_name = "Sometimes start with Sniper Bolt",
                ui_description = "When enabled, your starting wand may sometimes contain\nthe Sniper Bolt spell.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "sometimes_start_with_banana_bomb",
                ui_name = "Sometimes start with Banana Bomb",
                ui_description = "When enabled, your starting bomb wand may sometimes contain\nthe Banana Bomb spell.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "nerf_greek_spells",
                ui_name = "Make Greek spells limited-use",
                ui_description = "For when the Greek letter spells make the game too easy for you.\nYou'll have to get creative if you want unlimited spells...",
                value_default = false,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            -- {
            --     id = "afa_compat",
            --     ui_name = "Disable alt fire spells if Alt Fire Anything is enabled",
            --     ui_description = "If the Alt Fire Anything mod is enabled, disable this\nmod's individual alt fire spell variations.",
            --     value_default = true,
            --     scope = MOD_SETTING_SCOPE_NEW_GAME,
            -- },
            {
                id = "Spells",
                ui_name = "Enabled/disabled spells",
                ui_fn = mod_setting_vertical_spacing,
                not_setting = true,
            },
        },
    },
    {
        category_id = "enemy_settings",
        ui_name = "Enemies",
        ui_description = "",
        settings = {
            {
                id = "spawn_ancient_lurker_manually",
                ui_name = "Spawn Ancient Lurker manually",
                ui_description = "When enabled, the Ancient Lurker will appear only after\npicking up a specific nearby circular object.",
                value_default = false,
                scope = MOD_SETTING_SCOPE_RUNTIME,
            },
        },
    },
    {
        category_id = "content_toggles",
        ui_name = "Toggle individual reworks, spells and perks",
        ui_description = "",
        settings = {
        }
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

function do_custom_tooltip( callback, z, x_offset, y_offset )
    if z == nil then z = -12 end
    local left_click,right_click,hover,x,y,width,height,draw_x,draw_y,draw_width,draw_height = GuiGetPreviousWidgetInfo( gui );
    local screen_width,screen_height = GuiGetScreenDimensions( gui );
    if x_offset == nil then x_offset = 0; end
    if y_offset == nil then y_offset = 0; end
    if draw_y > screen_height * 0.5 then
        y_offset = y_offset - height;
    end
    if hover == 1 then
        local screen_width, screen_height = GuiGetScreenDimensions( gui );
        GuiZSet( gui, z );
        GuiLayoutBeginLayer( gui );
            GuiLayoutBeginVertical( gui, ( x + x_offset + width * 2 ) / screen_width * 100, ( y + y_offset ) / screen_height * 100 );
                GuiBeginAutoBox( gui );
                    if callback ~= nil then callback(); end
                    GuiZSetForNextWidget( gui, z + 1 );
                GuiEndAutoBoxNinePiece( gui );
            GuiLayoutEnd( gui );
        GuiLayoutEndLayer( gui );
    end
end

function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
  --  ModSettingSetNextValue(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
    screen_width, screen_height = GuiGetScreenDimensions(gui)

    mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )

    local id = 46323
    local function new_id() id = id + 1; return id end

    GuiOptionsAdd( gui, GUI_OPTION.NoPositionTween )

    --GuiLayoutBeginVertical( gui, 0, 0, false, 0, 3 )
    if(not in_main_menu)then

        -- PERK REWORKS
        dofile("mods/D2DContentPack/files/scripts/perks.lua")
        local filtered_perk_reworks = {}
        for i,perk in ipairs( d2d_perk_reworks ) do
            if not perk.not_in_default_perk_pool then
                table.insert( filtered_perk_reworks, perk )
            end
        end

        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Reworks" )then
            for k, v in pairs( filtered_perk_reworks ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Reworks" )then
            for k, v in pairs( filtered_perk_reworks ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( filtered_perk_reworks ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )


            local clicked,right_clicked = GuiImageButton( gui, new_id(), 0, 0, "", v.perk_icon )
            if clicked then
                if HasSettingFlag( v.id.."_disabled") then
                    RemoveSettingFlag( v.id.."_disabled" )
                else
                    AddSettingFlag( v.id.."_disabled" )
                    RemoveSettingFlag( v.id.."_spawn_at_start" )
                end
            end
            if right_clicked then
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    RemoveSettingFlag( v.id.."_spawn_at_start" )
                elseif not HasSettingFlag( v.id.."_disabled") then
                    AddSettingFlag( v.id.."_spawn_at_start" )
                end
            end

            local original_source = "the base game"
            if v.source_mod_name then
                original_source = v.source_mod_name
            end
            local tooltip_text = GameTextGetTranslatedOrNot(v.ui_description) .. "\n" .. "(Replaces '" .. v.ui_name_vanilla .. "' from " .. original_source .. ")"
            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, tooltip_text, "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, tooltip_text, "[ Click to disable]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, tooltip_text, "[ Click to disable]   [ Right-click to enable spawn at start ]" )
                end
            end

            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if HasSettingFlag( v.id.."_disabled" ) then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end

            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, tooltip_text, "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, tooltip_text, "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, tooltip_text, "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            if HasSettingFlag( v.id.."_spawn_at_start" ) then
                GuiColorSetForNextWidget( gui, 0, 1, 0, 1 )
            else
                GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
            end

            -- local new_ui_name = GameTextGetTranslatedOrNot( v.ui_name )
            -- local vanilla_ui_name = GameTextGetTranslatedOrNot( v.ui_name_vanilla )
            -- local name_to_show = vanilla_ui_name
            -- if new_ui_name ~= vanilla_ui_name then
            --     name_to_show = vanilla_ui_name .. " -> " .. new_ui_name
            -- end
            -- if v.source_mod_name then
            --     name_to_show = new_ui_name .. " (from mod: " .. v.source_mod_name .. ")"
            -- end
            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot( v.ui_name ) )
            GuiLayoutEnd(gui)
        end




        -- SPELLS
        dofile("mods/D2DContentPack/files/scripts/actions.lua")
        local filtered_actions = {}
        for i,action in ipairs( d2d_actions ) do
            if action.spawn_probability ~= "0" then
                table.insert( filtered_actions, action )
            end
        end
        if d2d_alt_fire_actions then
            for i,action in ipairs( d2d_alt_fire_actions ) do
                if action.spawn_probability ~= "0" then
                    table.insert( filtered_actions, action )
                end
            end
        end

        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Spells" )then
            for k, v in pairs( filtered_actions ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Spells" )then
            for k, v in pairs( filtered_actions ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( filtered_actions ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )

            local clicked,right_clicked = GuiImageButton( gui, new_id(), 0, 0, "", v.sprite )
            if clicked then
                if HasSettingFlag( v.id.."_disabled") then
                    RemoveSettingFlag(v.id.."_disabled")
                else
                    AddSettingFlag(v.id.."_disabled")
                    RemoveSettingFlag(v.id.."_spawn_at_start")
                end
            end
            if right_clicked then
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    RemoveSettingFlag(v.id.."_spawn_at_start")
                elseif not HasSettingFlag( v.id.."_disabled") then
                    AddSettingFlag(v.id.."_spawn_at_start")
                end
            end

            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" )
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            -- GuiImage( gui, new_id(), -36.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if(HasSettingFlag(v.id.."_disabled"))then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end

            if HasSettingFlag( v.id.."_disabled" ) then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" )
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            if HasSettingFlag( v.id.."_spawn_at_start" ) then
                GuiColorSetForNextWidget( gui, 0, 1, 0, 1 )
            else
                GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
            end
            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.name) )

            
            GuiLayoutEnd(gui)
            
        end





        -- PERKS
        local filtered_perks = {}
        for i,perk in ipairs( d2d_perks ) do
            if not perk.not_in_default_perk_pool then
                table.insert( filtered_perks, perk )
            end
        end
        -- if d2d_apoth_perks then
        --     for i,perk in ipairs( d2d_apoth_perks ) do
        --         if not perk.not_in_default_perk_pool then
        --             table.insert( filtered_perks, perk )
        --         end
        --     end
        -- end

        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Perks" )then
            for k, v in pairs( filtered_perks ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Perks" )then
            for k, v in pairs( filtered_perks ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( filtered_perks ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )


            local clicked,right_clicked = GuiImageButton( gui, new_id(), 0, 0, "", v.perk_icon )
            if clicked then
                if HasSettingFlag( v.id.."_disabled") then
                    RemoveSettingFlag(v.id.."_disabled")
                else
                    AddSettingFlag(v.id.."_disabled")
                    RemoveSettingFlag(v.id.."_spawn_at_start")
                end
            end
            if right_clicked then
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    RemoveSettingFlag( v.id.."_spawn_at_start" )
                elseif not HasSettingFlag( v.id.."_disabled") then
                    AddSettingFlag( v.id.."_spawn_at_start" )
                end
            end

            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if(HasSettingFlag(v.id.."_disabled"))then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end

            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to enable ]" );
            else
                if HasSettingFlag( v.id.."_spawn_at_start" ) then
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to disable spawn at start]" )
                else
                    GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ]   [ Right-click to enable spawn at start ]" )
                end
            end

            if HasSettingFlag( v.id.."_spawn_at_start" ) then
                GuiColorSetForNextWidget( gui, 0, 1, 0, 1 )
            else
                GuiColorSetForNextWidget( gui, 1, 1, 1, 1 )
            end
            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.ui_name) )
            GuiLayoutEnd(gui)
        end
    else
        GuiColorSetForNextWidget( gui, 1, 0, 0, 1 )
        GuiText( gui, 0, 0, "Individual spells and perks can only be enabled/disabled in-game." )
    end
    for i = 1, 5 do
        GuiText( gui, 0, 0, "" )
    end
    --GuiLayoutEnd(gui)
end