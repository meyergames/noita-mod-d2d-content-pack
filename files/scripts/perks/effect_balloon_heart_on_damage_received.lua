dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( entity_id )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local responsible_entity_tags = EntityGetTags( entity_thats_responsible )
    local responsible_entity_is_mortal = responsible_entity_tags and string.find( responsible_entity_tags, "mortal" )

	if ( responsible_entity_is_mortal or projectile_thats_responsible ~= 0 ) and damage > 0 then
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/polymorph_bubble/destroy", x, y )
		EntityRemoveComponent( owner, get_internal_int( owner, "balloon_heart_lua_comp_id" ) )
		GamePrintImportant( "The Balloon Heart popped")
	end
end
