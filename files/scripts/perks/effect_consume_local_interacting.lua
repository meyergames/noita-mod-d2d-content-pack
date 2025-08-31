dofile_once( "data/scripts/lib/utilities.lua" )

function interacting( entity_who_interacted, entity_interacted, interactable_name )
	local EZWand = dofile_once("mods/RiskRewardBundle/files/scripts/lib/ezwand.lua")
   	if ( not EZWand.IsWand( entity_interacted ) ) then return end
   	local wand = EZWand.GetHeldWand()
   	local x, y = EntityGetTransform( entity_interacted )

   	addNewInternalVariable( wand, "pickup_pos_x", "value_int", x )
   	addNewInternalVariable( wand, "pickup_pos_y", "value_int", y )
end