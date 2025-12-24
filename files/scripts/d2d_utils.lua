dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

function determine_blink_dmg_mtp()
	-- first check the staff
    local wand = EZWand.GetHeldWand()
    if wand then
    	local tier = get_internal_int( wand.entity_id, "staff_of_time_tier" )
    	if tier == 3 then
    		return 0.02
    	elseif tier == 2 then
    		return 0.05
    	elseif tier == 1 then
    		return 0.10
    	end
    end

    -- if the spell is cast outside of the Staff of Time, check the player's highest time trial completion tier
    if HasFlagPersistent( "d2d_time_trial_gold" ) then
    	return 0.02
    elseif HasFlagPersistent( "d2d_time_trial_silver" ) then
    	return 0.05
    else
    	return 0.10
    end
end

function player_take_max_hp_dmg( ratio, can_kill )
	GamePrint( "<function not implemented>" )
end