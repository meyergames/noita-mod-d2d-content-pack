dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()

-- double the projectile's damage, including modifiers
multiply_proj_dmg( proj_id, 2.0 )

-- change the projectile sprite
local sprite_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "SpriteComponent" )
if exists( sprite_comp ) then
	ComponentSetValue2( sprite_comp, "image_file", "mods/D2DContentPack/files/gfx/projectiles_gfx/echo_shot_red.xml" )
end

-- change the explosion sprite
local proj_comp = EntityGetFirstComponentIncludingDisabled( proj_id, "ProjectileComponent" )
if exists( proj_comp ) then
	ComponentObjectSetValue2( proj_comp, "config_explosion", "explosion_sprite",
		"mods/D2DContentPack/files/gfx/projectiles_gfx/explosion_016_red.xml" )
end

-- change the particle colors
local particle_comps = EntityGetComponentIncludingDisabled( proj_id, "ParticleEmitterComponent" )
if exists( particle_comps ) then
	for i,particle_comp in ipairs( particle_comps ) do
		ComponentSetValue2( particle_comp, "emitted_material_name", "spark_red_bright" )
	end
end

-- play a small explosion in the original colour to better communicate the transition
local x, y = EntityGetTransform( proj_id )
EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/echo_shot_fake_explosion.xml", x, y )
