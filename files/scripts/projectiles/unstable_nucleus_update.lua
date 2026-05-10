dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

-- entity id and internal vars
local entity_id = GetUpdatedEntityID()
local wand_id = get_internal_int( entity_id, "source_wand_id" )
local max_charges = get_internal_int( entity_id, "max_charges" )
local p_x, p_y = EntityGetTransform( get_player() )
local x, y = EntityGetTransform( entity_id )

local controlscomp = EntityGetFirstComponent( get_player(), "ControlsComponent")
local aim_x, aim_y = ComponentGetValue2(controlscomp, "mAimingVectorNormalized")

local wand_hscomp = EntityGetFirstComponentIncludingDisabled( wand_id, "HotspotComponent" )
local wand_x_offset, wand_y_offset = ComponentGetValueVector2( wand_hscomp, "offset" )

-- ezwand vars
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local wand = EZWand.GetHeldWand()
local wand_x, wand_y = EntityGetTransform( wand_id )

-- charge the projectile, or end this function if mana is empty
local charges = get_internal_int( entity_id, "charges" )
if not charges then charges = 0 end 
local charges_to_add = ( ( wand.manaMax * 0.1 ) / 10 ) -- / 10 because this script is only called 10 times per second
local expl_radius = 25 + ( charges * 0.05 )
-- wand.mana = math.max( wand.mana - charges_to_add, 1 )
if wand.mana > 10 then
	-- add charges to projectile
	raise_internal_int( entity_id, "charges", charges_to_add )
	charges = get_internal_int( entity_id, "charges" )

	-- determine and set pull radius var
	local max_pull_radius = expl_radius
	local current_pull_radius = max_pull_radius * 0.5 + ( ( max_pull_radius * 0.5 ) / max_charges ) * charges
	set_internal_int( entity_id, "pull_radius", current_pull_radius )

	if wand.mana > wand.manaMax * 0.15 then

		-- spawn particles from the player's wand
		local theta = math.random() * 2 * math.pi
		local x_offset = math.cos(theta) * 5
		local y_offset = math.sin(theta) * 5
	    local dir_x = ( x + x_offset ) - x
		local dir_y = ( y + y_offset ) - y

		local ox = wand_x + ( aim_x * 24 ) + dir_x
		local oy = wand_y + ( aim_y * 24 ) + dir_y
		shoot_projectile( wand_id, "mods/D2DContentPack/files/entities/projectiles/deck/unstable_nucleus_charge_white.xml", ox, oy, dir_x * 20, dir_y * 20 )

		-- spawn particles within the projectile's radius
		for i=1,math.floor( 1 + ( charges * 0.004 ) ) do
			theta = math.random() * 2 * math.pi
			local randomRadius = Random( expl_radius * 0.5, expl_radius ) * math.max( charges * 0.001, 1.0 )
			x_offset = math.cos(theta) * randomRadius
			y_offset = math.sin(theta) * randomRadius
			dir_x = ( x + x_offset ) - x
			dir_y = ( y + y_offset ) - y

			shoot_projectile( entity_id, "mods/D2DContentPack/files/entities/projectiles/deck/unstable_nucleus_charge.xml", x + x_offset, y + y_offset, 0, 0 )
		end
	end
end

local is_fire_pressed = is_fire_pressed() or is_alt_fire_pressed()
if not is_fire_pressed or wand.mana <= 10 or wand.entity_id ~= wand_id then
	local proj_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "ProjectileComponent" )
	ComponentObjectSetValue2( proj_comp, "config_explosion", "explosion_radius", 25 + ( charges * 0.05 ) ) -- 75 at 1000 charges
	ComponentObjectSetValue2( proj_comp, "config_explosion", "damage", 2.4 + ( charges * 0.0216 ) ) -- 600 at 1000 charges
	ComponentObjectSetValue2( proj_comp, "config_explosion", "max_durability_to_destroy", 10 + math.floor( charges / 250 ) ) -- can destroy brickwork at 1000 charges
	ComponentObjectSetValue2( proj_comp, "config_explosion", "ray_energy", 4500000 + ( charges * 9000 ) ) -- tripled at 1000 charges
	ComponentObjectSetValue2( proj_comp, "config_explosion", "camera_shake", 10 + ( charges * 0.09 ) ) -- 100 at 1000 charges
	ComponentObjectSetValue2( proj_comp, "config_explosion", "knockback_force", 1.0 + ( charges * 0.004 ) ) -- 5.0 at 1000 charges
	-- GamePrint( "Exploded with " .. charges .. " charges" )

	local light_comp = EntityGetFirstComponentIncludingDisabled( entity_id, "LightComponent" )
	ComponentSetValue2( light_comp, "radius", 60 + ( charges * 0.12 ) )
	
	-- local acomp = EntityGetFirstComponentIncludingDisabled( wand.entity_id, "AbilityComponent" )
	-- local reload_time = charges * 0.12
	-- ComponentSetValue2( acomp, "mReloadNextFrameUsable", GameGetFrameNum() + reload_time )
	-- ComponentSetValue2( acomp, "mReloadFramesLeft", reload_time )
	-- ComponentSetValue2( acomp, "reload_time_frames", reload_time )

	EntityKill( entity_id )

	local particles = EntityGetWithTag( "d2d_unstable_nucleus_particle" )
	if exists( particles ) then
		for i,particle in ipairs( particles ) do
			set_internal_bool( particle, "d2d_unstable_nucleus_particle_expended", true )
		end
	end
end