dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.
dofile("data/scripts/lib/utilities.lua")

local mod_id = "v2drrb"
mod_settings_version = 1
mod_settings = 
{
	{
        id = "Spells",
        ui_name = "Spells",
		ui_fn = mod_setting_vertical_spacing,
		not_setting = true,
	},
	{
		id = "time_trial_on_start",
		ui_name = "Spawn Time Trial at start",
		ui_description = "Start each run with the Time Trial perk spawned at the mountain entrance",
		value_default = false,
	},
}

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end


function do_custom_tooltip( callback, z, x_offset, y_offset )
    if z == nil then z = -12; end
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
		dofile("mods/RiskRewardBundle/files/scripts/actions.lua")
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

		crossed_index = 1
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

			GuiImage( gui, new_id(), -20.2, -1.2, "mods/spellbound_bundle/files/gfx/ui_gfx/square.png", 1, 1.2, 0 )
			if(HasSettingFlag(v.id.."_disabled"))then
				GuiZSetForNextWidget( gui, -80 )
				GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
				GuiImage( gui, new_id(), -20.2, -1.2, "mods/spellbound_bundle/files/gfx/ui_gfx/overlay.png", 1, 1.2, 0 )
				GuiZSetForNextWidget( gui, -90 )
				GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
				GuiImage( gui, new_id(), -20, 0, "mods/spellbound_bundle/files/gfx/ui_gfx/crossed"..crossed_index..".png", 1, 1, 0 )
			end


			if(HasSettingFlag(v.id.."_disabled"))then
				GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to enable ]" );
			else
				GuiTooltip( gui, GameTextGetTranslatedOrNot(v.description), "[ Click to disable] " );
			end

			if(crossed_index < 5)then
				crossed_index = crossed_index + 1
			else
				crossed_index = 1
			end

			GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.name) )

			
			GuiLayoutEnd(gui)
			
		end





        -- PERKS
		dofile("mods/RiskRewardBundle/files/scripts/perks.lua")
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

		crossed_index = 1
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
				GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable] " );
			end

			GuiImage( gui, new_id(), -20.2, -1.2, "mods/spellbound_bundle/files/gfx/ui_gfx/square.png", 1, 1.2, 0 )
			if(HasSettingFlag(v.id.."_disabled"))then
				GuiZSetForNextWidget( gui, -80 )
				GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
				GuiImage( gui, new_id(), -20.2, -1.2, "mods/spellbound_bundle/files/gfx/ui_gfx/overlay.png", 1, 1.2, 0 )
				GuiZSetForNextWidget( gui, -90 )
				GuiOptionsAddForNextWidget(gui, GUI_OPTION.NonInteractive)
				GuiImage( gui, new_id(), -20, 0, "mods/spellbound_bundle/files/gfx/ui_gfx/crossed"..crossed_index..".png", 1, 1, 0 )
			end


			if(HasSettingFlag(v.id.."_disabled"))then
				GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to enable ]" );
			else
				GuiTooltip( gui, GameTextGetTranslatedOrNot(v.ui_description), "[ Click to disable] " );
			end

			if(crossed_index < 5)then
				crossed_index = crossed_index + 1
			else
				crossed_index = 1
			end

			GuiText( gui, 0, 3, GameTextGetTranslatedOrNot(v.ui_name) )

			
			GuiLayoutEnd(gui)
			
		end





		--[[
		for i = 1, 100 do
			GuiText( gui, 0, 0, "" )
		end
		]]
		--GuiLayoutEnd(gui)
		--GuiEndScrollContainer(gui)
	else
		GuiText( gui, 0, 0, "Due to a Noita limitation, \noptions are only available in-game." )
	end
	for i = 1, 5 do
		GuiText( gui, 0, 0, "" )
	end
	--GuiLayoutEnd(gui)
end
