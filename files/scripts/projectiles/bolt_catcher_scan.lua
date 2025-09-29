dofile_once( "data/scripts/lib/utilities.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )

local p_dcomp = EntityGetFirstComponentIncludingDisabled( get_player(), "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

for _,proj_id in pairs( EntityGetInRadiusWithTag( x, y, 20, "projectile" ) ) do
	local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
	local proj_source = ComponentGetValue2( proj_comp, "mWhoShot" )

	-- only heal the player if the projectile isn't theirs
	if proj_source ~= get_player() then
		-- determine heal ratio based on the projectile's velocity
		local proj_velocity = ComponentGetValue2( proj_comp, "speed_min" ) -- default value, just in case
	    local vcomp = EntityGetFirstComponentIncludingDisabled( proj_id, "VelocityComponent" )
	    if vcomp ~= nil then
	        local vx, vy = ComponentGetValue2( vcomp, "mVelocity" )
	        proj_velocity = get_magnitude( vx, vy )
	    end
		local heal_ratio = remap( proj_velocity, 100, 1000, 0.5, 1.0 )

		-- heal the player
		local proj_dmg = ComponentGetValue2( proj_comp, "damage" )
		local proj_x, proj_y = EntityGetTransform( proj_id )
	    ComponentSetValue( p_dcomp, "hp", math.min( p_hp + ( proj_dmg * heal_ratio ), p_max_hp ) )
	    GamePlaySound( "data/audio/Desktop/projectiles.bank", "projectiles/glowing_laser/destroy", proj_x, proj_y )
		EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/bolt_catcher_heal.xml", proj_x, proj_y )
	end

    -- "disable" the projectile's explosion
	ComponentObjectSetValue2( proj_comp, "config_explosion", "explosion_radius", 0 )
    ComponentObjectSetValue2( proj_comp, "config_explosion", "create_cell_probability", 0 )
    ComponentObjectSetValue2( proj_comp, "config_explosion", "damage", 0 )
    ComponentObjectSetValue2( proj_comp, "config_explosion", "damage_mortals", 0 )

    -- destroy the projectile
	EntityKill( proj_id )
end
