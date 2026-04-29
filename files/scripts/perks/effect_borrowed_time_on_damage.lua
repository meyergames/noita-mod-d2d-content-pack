dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	if EntityHasTag( entity_thats_responsible, "d2d_perk_borrowed_time" ) then return end

	local player = GetUpdatedEntityID()
    for _,dcomp in ipairs( EntityGetComponent( player, "DamageModelComponent" ) or {} ) do
    	-- first do x4 since it was reduced by x4 in on_damage_incoming
		raise_internal_float( player, "d2d_borrowed_time_stored_dmg", damage * 4 * 0.75 )
	end
end

-- -- old method that spread high damage over multiple seconds
-- function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
-- 	if dcomp ~= nil and entity_thats_responsible ~= nil then
-- 		local hp = ComponentGetValue2( dcomp, "hp" )
-- 		local max_hp = ComponentGetValue2( dcomp, "max_hp" )
-- 		if damage < math.max( hp * 0.2, 0.8 ) then return end -- skip splitting if dmg was less than 20 or 20% of the player's current health

-- 		local new_damage = damage * 0.5
-- 		setInternalVariableValue( owner, "borrowed_time_last_damage_frame", "value_int", GameGetFrameNum() )
-- 		setInternalVariableValue( owner, "borrowed_time_remaining_damage", "value_float", damage * 0.5 )

-- 		return new_damage, critical_hit_chance -- new_damage:number,new_critical_hit_chance:int 
-- 	else
-- 		return damage, critical_hit_chance
-- 	end
-- end