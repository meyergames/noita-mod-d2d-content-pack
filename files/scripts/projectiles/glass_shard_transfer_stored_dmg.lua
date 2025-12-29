dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local nearest_target = EntityGetInRadiusWithTag( x, y, 20, "homing_target" )[1] or nil -- TODO: decrease radius somehow
if exists( nearest_target ) then

	local stored_dmg = get_internal_float( entity_id, "d2d_glass_shard_bonus_dmg" )
	raise_internal_float( nearest_target, "d2d_glass_shard_bonus_dmg", stored_dmg )

	-- reset so another projectile does not also gain the copy
	EntityKill( entity_id )
	-- set_internal_float( entity_id, "d2d_glass_shard_bonus_dmg", 0 )
end

-- pass the dmg to the shard entity
-- local postponed_dmg = GlobalsGetValue( "d2d_glass_shard_postponed_bonus_dmg" )
-- if exists( postponed_dmg ) then
-- 	set_internal_float( shard_entity, "d2d_glass_shard_stored_bonus_damage", postponed_dmg )
-- end

-- -- reset for the next projectile
-- GlobalsSetValue( "d2d_glass_shard_postponed_bonus_dmg", 0 )
