dofile_once("data/scripts/lib/utilities.lua")

function init( entity_id )
	local potion_material = "magic_liquid_infected_healthium"	
    local total_capacity = 60

	AddMaterialInventoryMaterial( entity_id, potion_material, total_capacity )
end
