-- REQUIRES APOTHEOSIS MOD INSTALLED

dofile_once("mods/Apotheosis/lib/apotheosis/apotheosis_utils.lua")
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local cooldown_frames = 60
local actionid = "action_d2d_alt_fire_anything"
local cooldown_frame
local variablecomp = EntityGetFirstComponentIncludingDisabled( entity_id, "VariableStorageComponent" )
cooldown_frame = ComponentGetValue2( variablecomp, "value_int" )
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")
local manacost = 0

if GameGetFrameNum() >= cooldown_frame then
    if isButtonDown_AltFire() then
        local mana = wand.mana

		local spell_sequence = {}
		local acomp = EntityGetFirstComponentIncludingDisabled( wand.entity_id, "AbilityComponent" )
		local next_usable_frame = ComponentGetValue2( acomp, "mReloadNextFrameUsable" )
		if ( GameGetFrameNum() < next_usable_frame ) then return end -- return if the wand is reloading

		local afa_index = -1
		local total_mana_drain = 0
        local spells, attached_spells = wand:GetSpells()
        for i,spell in ipairs( spells ) do
            if ( spell.action_id == "D2D_ALT_FIRE_ANYTHING" ) then
            	afa_index = i
            elseif ( i > afa_index ) then
			    local spell_eid = spells[i].entity_id
		        local spell_aid = spells[i].action_id
		        local spelldata = fetch_spell_data( spell_aid )

		        local icomp = EntityGetFirstComponentIncludingDisabled( spell_eid, "ItemComponent" )
		        local uses_remaining = ComponentGetValue2( icomp, "uses_remaining" ) or -1
		        if wand.mana >= total_mana_drain + spelldata.mana then
		        	if ( uses_remaining ~= 0 ) then -- either it is -1 for infinite, or >0 for actual remaining uses
		        		total_mana_drain = total_mana_drain + spelldata.mana
		        		spell_sequence[i-afa_index] = spell_aid

			        	if uses_remaining > 0 then
	                    	ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )
	                    end
		        	end
		        end
		    end
        end

    	if ( wand.mana >= total_mana_drain ) then
			EZWand.ShootSpellSequenceInherit( spell_sequence, x+aim_x*12, y+aim_y*12, x+aim_x*20, y+aim_y*20, wand )
			wand.mana = wand.mana - total_mana_drain

			-- local action_cast_delay = ComponentObjectGetValue2( acomp, "gunaction_config", "fire_rate_wait" )
			-- local action_recharge_time = ComponentObjectGetValue2( acomp, "gunaction_config", "reload_time" )
			local wand_recharge_time = ComponentObjectGetValue2( acomp, "gun_config", "reload_time" )
			-- local total_recharge_time = action_recharge_time + wand_recharge_time
	        ComponentSetValue2( acomp, "mNextFrameUsable", GameGetFrameNum() + wand_recharge_time )
	        ComponentSetValue2( acomp, "mReloadNextFrameUsable", GameGetFrameNum() + wand_recharge_time )
	        ComponentSetValue2( acomp, "mReloadFramesLeft", wand_recharge_time )
	        ComponentSetValue2( acomp, "reload_time_frames", wand_recharge_time )

			ComponentSetValue2( variablecomp, "value_int", GameGetFrameNum() + wand_recharge_time )
	        if HasFlagPersistent(actionid) == false then
	            GameAddFlagRun(table.concat({"new_",actionid}))
	            AddFlagPersistent(actionid)
	        end
            -- if ModIsEnabled("quant.ew") then
            --     CrossCall("afa_ew_alt_fire", root, x, y, aim_x, aim_y, "???.xml")
            -- end
        else
        	GamePlaySound("data/audio/Desktop/items.bank", "magic_wand/not_enough_mana_for_action", x, y)
	    end
    end
end