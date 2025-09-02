dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()
local owner = entity_id

-- function damage_about_to_be_received( damage, x, y, entity_thats_responsible, critical_hit_chance )
-- 	if dcomp ~= nil then
-- 		local hp = ComponentGetValue2( dcomp, "hp" )
-- 		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

-- 		GamePrint("damage: " .. damage .. "  |  hp: " .. hp .. "  |  max hp: " .. max_hp)
-- 		if damage >= hp and damage < max_hp then
-- 			local max_hp_loss = damage - hp
-- 			ComponentSetValue2( dcomp, "max_hp", max_hp - max_hp_loss )
-- 			if max_hp_loss > math.max( max_hp * 0.1, 0.4 ) then
-- 				GamePrint( "You survive, but lose " .. max_hp_loss .. " max health." )
-- 			end

-- 			GamePrint( "damage dealt: " .. math.min( damage, hp - 0.04 ) .. "/" .. hp )
--         	local capped_damage = math.min( hp - 0.04, damage )
-- 			return capped_damage, critical_hit_chance
-- 		end
-- 	end

-- 	GamePrint("effect was ignored")
-- 	return damage, critical_hit_chance
-- end

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
    for _,dcomp in ipairs( EntityGetComponent( owner, "DamageModelComponent" ) or {} ) do
		local hp = ComponentGetValue2( dcomp, "hp" )
		local max_hp = ComponentGetValue2( dcomp, "max_hp" )

		if damage >= hp and damage < max_hp then
			-- reduce the player's max hp
			local max_hp_loss = 2 * ( damage - hp + 0.04 )
			ComponentSetValue2( dcomp, "max_hp", max_hp - max_hp_loss )
			if max_hp_loss > math.max( max_hp * 0.1, 0.4 ) then
				GamePrint( "You survive, but lose " .. string.format( "%d", ( max_hp_loss * 25 ) ) .. " max health." )
			end

			-- make the player stay at 1 hp
			ComponentSetValue2( dcomp, "hp", damage + 0.04 )
		end
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