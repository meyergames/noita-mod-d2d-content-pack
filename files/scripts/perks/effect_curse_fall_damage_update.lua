dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( owner )

local vcomp = EntityGetFirstComponentIncludingDisabled( owner, "VelocityComponent" )
if vcomp ~= nil then
	local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
	local p_hp = ComponentGetValue2( p_dcomp, "hp" )
	local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

	-- check if the player was on the ground last frame
	local was_on_ground = get_internal_bool( owner, "brittle_bones_was_on_ground_last_frame" )

	-- check if the player is on the ground now
	local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
	local is_on_ground = ComponentGetValue2( cdatacomp, "is_on_ground" )

	-- apply fall damage if the player falls fast enough
	local last_vel_y = get_internal_float( owner, "brittle_bones_velocity_y_last_frame" )
    if not was_on_ground and is_on_ground and last_vel_y > 4 then
    	local dmg = ( last_vel_y - 4 ) * 10 -- max. 1.8 * 10 = 18 (since 5.8 seems to be terminal velocity)
        GamePlaySound( "data/audio/Desktop/player.bank", "player/damage/melee", x, y )
        EntityInflictDamage( get_player(), dmg * 0.04, "NONE", "falling", "NONE", 0, 0, owner, x, y, 0 )
    end

    -- save variables for next frame
    local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
    set_internal_float( owner, "brittle_bones_velocity_y_last_frame", vy )
	set_internal_bool( owner, "brittle_bones_was_on_ground_last_frame", is_on_ground )

end
