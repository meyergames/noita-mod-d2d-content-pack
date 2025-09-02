dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local owner		   = EntityGetParent( entity_id )
	
	if( damage < 0 ) then return end
	if ( entity_who_caused == owner ) or ( owner ~= NULL_ENTITY ) and ( entity_who_caused == EntityGetParent( owner ) ) then return end

	if ( distance_between( owner, entity_who_caused ) < 50 ) then
		LoadGameEffectEntityTo( owner, "data/entities/misc/effect_electrified.xml" )
	end
end