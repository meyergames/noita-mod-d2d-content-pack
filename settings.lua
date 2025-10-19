dofile("data/scripts/lib/mod_settings.lua")

local mod_id = "D2DContentPack" -- This should match the name of your mod's folder.
mod_settings_version = 1      -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
    {
        category_id = "default_settings",
        ui_name = "Build version: 25.10.19.1",
        ui_description = "",
        settings = {
        }
    },
    {
        category_id = "perk_settings",
        ui_name = "Perks",
        ui_description = "",
        settings = {
            {
                id = "spawn_time_trial_at_start",
                ui_name = "Sometimes spawn Time Trial at start",
                ui_description = "When enabled, there's a 5% chance for a copy of the\nTime Trial perk to spawn at the mountain entrance.",
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
                id = "afa_compat",
                ui_name = "Disable alt fire spells if Alt Fire Anything is enabled",
                ui_description = "If the Alt Fire Anything mod is enabled, disable this\nmod's individual alt fire spell variations.",
                value_default = true,
                scope = MOD_SETTING_SCOPE_NEW_GAME,
            },
            {
                id = "Spells",
                ui_name = "Enabled/disabled spells",
                ui_fn = mod_setting_vertical_spacing,
                not_setting = true,
            },
        },
    },
    {
        category_id = "content_toggles",
        ui_name = "Toggle individual spells and perks",
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


    
        --GuiBeginScrollContainer( gui, new_id(), 0, 0, 200, 150, true, 2, 2 )
        --GuiLayoutBeginVertical( gui, 0, 0, false, 2, 2 )




        
        -- SPELLS
        dofile("mods/D2DContentPack/files/scripts/actions.lua")
        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Spells" )then
            for k, v in pairs( d2d_actions ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Spells" )then
            for k, v in pairs( d2d_actions ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)
        
        for k, v in pairs( d2d_actions ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )

            if GuiImageButton( gui, new_id(), 0, 0, "", v.sprite ) then
                if(HasSettingFlag(v.id.."_disabled"))then
                    RemoveSettingFlag(v.id.."_disabled")
                else
                    AddSettingFlag(v.id.."_disabled")
                end
            end

            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" );
            else
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable] " );
            end

            GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_square.png", 1, 1.2, 0 )
            if(HasSettingFlag(v.id.."_disabled"))then
                GuiZSetForNextWidget( gui, -80 )
                GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
                GuiImage( gui, new_id(), -20.2, -1.2, "mods/D2DContentPack/files/gfx/ui_gfx/settings_content_disabled_overlay.png", 1, 1.2, 0 )
            end


            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" );
            else
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable] " );
            end

            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.name) )

            
            GuiLayoutEnd(gui)
            
        end





        -- PERKS
        dofile("mods/D2DContentPack/files/scripts/perks.lua")
        GuiLayoutBeginHorizontal( gui, 0, 0, false, 15, 10 )
        if GuiButton( gui, new_id(), 0, 0, "Enable All Perks" )then
            for k, v in pairs( d2d_perks ) do
                RemoveSettingFlag(v.id.."_disabled")
            end
        end
        if GuiButton( gui, new_id(), 0, 0, "Disable All Perks" )then
            for k, v in pairs( d2d_perks ) do
                AddSettingFlag(v.id.."_disabled")
            end
        end
        GuiLayoutEnd(gui)

        for k, v in pairs( d2d_perks ) do

            GuiLayoutBeginHorizontal( gui, 0, 0, false, 2, 2 )

            if GuiImageButton( gui, new_id(), 0, 0, "", v.perk_icon ) then
                if(HasSettingFlag(v.id.."_disabled"))then
                    RemoveSettingFlag(v.id.."_disabled")
                else
                    AddSettingFlag(v.id.."_disabled")
                end
            end

            if(HasSettingFlag(v.id.."_disabled"))then
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to enable ]" );
            else
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ] " );
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
                GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable ] " );
            end

            GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.ui_name) )
            GuiLayoutEnd(gui)
        end
    else
        -- GuiText( gui, 0, 0, "Due to a Noita limitation, \noptions are only available in-game." )
        GuiText( gui, 0, 0, "Individual spells and perks \ncan be enabled/disabled in-game." )
    end
    for i = 1, 5 do
        GuiText( gui, 0, 0, "" )
    end
    --GuiLayoutEnd(gui)
end