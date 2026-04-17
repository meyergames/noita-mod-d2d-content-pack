dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local is_listening = get_internal_bool( GetUpdatedEntityID(), "d2d_auto_reload_listening" )
if is_fire_pressed() or is_alt_fire_pressed() and not is_listening then
	set_internal_bool( GetUpdatedEntityID(), "d2d_auto_reload_listening", true )
end

if not is_fire_pressed() and not is_alt_fire_pressed() and is_listening then
	local wand = EZWand.GetHeldWand()
	local acomp = EntityGetFirstComponentIncludingDisabled( wand.entity_id, "AbilityComponent" )
	local next_frame_usable = ComponentGetValue2( acomp, "mReloadNextFrameUsable" )
	if GameGetFrameNum() > next_frame_usable then
		trigger_wand_refresh( wand )
	end

	set_internal_bool( GetUpdatedEntityID(), "d2d_auto_reload_listening", false )
end
