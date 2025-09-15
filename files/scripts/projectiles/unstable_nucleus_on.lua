dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local wand = EZWand.GetHeldWand()

local max_charges = wand.manaMax
local source_wand_id = wand.entity_id
set_internal_int( entity_id, "max_charges", max_charges )
set_internal_int( get_player(), "unstable_nucleus_id", entity_id )
set_internal_int( entity_id, "source_wand_id", source_wand_id )

local spells, attached_spells = wand:GetSpells()
for i,spell in ipairs( spells ) do
    if ( spell.action_id == "D2D_UNSTABLE_NUCLEUS" ) then
		local uses_remaining = -1
		local icomp = EntityGetFirstComponentIncludingDisabled( spell.entity_id, "ItemComponent" )
		if ( icomp ~= nil ) then
		    uses_remaining = ComponentGetValue2( icomp, "uses_remaining" )
	        ComponentSetValue2( icomp, "uses_remaining", uses_remaining - 1 )
	        if ( uses_remaining == 1 ) then
				local x, y = EntityGetTransform( get_player() )
	            GamePlaySound( "data/audio/Desktop/items.bank", "magic_wand/action_consumed", x, y )
	            EntityLoad("mods/D2DContentPack/files/particles/fade_unstable_nucleus.xml", x, y )
	        end

	        break
		end
    end
end
