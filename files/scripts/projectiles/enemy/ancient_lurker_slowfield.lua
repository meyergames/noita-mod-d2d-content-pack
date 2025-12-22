dofile_once("data/scripts/lib/utilities.lua")

local lurker = EntityGetWithName( "$animal_d2d_ancient_lurker" )
local x, y = EntityGetTransform( lurker )
local distance_full = 48

local projs_to_kill = {}
local projectiles = EntityGetInRadiusWithTag( x, y, distance_full, "player_projectile" )
if #projectiles > 0 then
	for i,proj_id in ipairs( projectiles ) do
		table.insert( projs_to_kill, proj_id )
	end
end

if get_internal_bool( lurker, "d2d_ancient_lurker_shield_is_active" ) then
	for i,proj in ipairs( projs_to_kill ) do
		local px, py = EntityGetTransform( proj )
		local flame_id = EntityLoad( "data/entities/projectiles/darkflame_stationary.xml", px, py )
		ComponentSetValue2( EntityGetFirstComponent( flame_id, "ProjectileComponent" ), "mWhoShot", lurker )

		local dcomp = EntityGetFirstComponent( lurker, "DamageModelComponent" )
		if dcomp then
			local hp = ComponentGetValue2( dcomp, "hp" )
			local max_hp = ComponentGetValue2( dcomp, "max_hp" )
			ComponentSetValue2( dcomp, "hp", math.min( hp + 0.2, max_hp ) )
		end

		EntityKill( proj )
	end
end