dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = get_player()

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    for _,dcomp in ipairs( EntityGetComponent( owner, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		local trigger_threshold = ModSettingGet( "D2DContentPack.auto_emergency_injection_threshold" )
		if trigger_threshold > 0 and hp - damage <= max_hp * trigger_threshold then
			-- check if the player has an emergency injection with them
			local em_inj_id = -1
			local children = EntityGetAllChildren( get_player() )
			for k=1,#children do
				child = children[k]
			    if EntityGetName( child ) == "inventory_quick" then
			        local inventory_items = EntityGetAllChildren(child)
			        if( inventory_items ~= nil ) then
			            for z=1, #inventory_items do
			            	item = inventory_items[z]

			            	local item_comp = EntityGetFirstComponentIncludingDisabled( item, "ItemComponent" )
			            	if item_comp then
			            		local item_name = ComponentGetValue2( item_comp, "item_name" )
			            		if item_name == "$item_d2d_emergency_injection_name" then
			            			em_inj_id = item
			            		end
			            	end
			            end
			        end
			    end
			end

			if em_inj_id ~= -1 then
				ComponentSetValue2( dcomp, "hp", damage + 0.04 )
	    		EntityIngestMaterial( owner, CellFactory_GetType( "magic_liquid_infected_healthium" ), 60 )
				EntityKill( em_inj_id )
			end
		end
	end
end
