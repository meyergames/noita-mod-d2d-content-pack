dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EFFECT_RADIUS = 100

local entity_id = GetUpdatedEntityID()
local owner = EntityGetParent( entity_id )
local x, y = EntityGetTransform( owner )

local is_immune_to_electricity = has_game_effect( owner, "PROTECTION_ELECTRICITY" )
if is_immune_to_electricity then
    -- remove_perk( "D2D_MASTER_OF_FIRE" )
    return
end

function zap()
	local nearby_targets = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS, "homing_target" )
	if exists( nearby_targets ) and #nearby_targets >= 1 then

		-- play sfx/vfx
	    GamePlaySound( "data/audio/Desktop/materials.bank", "materials/electric_spark", x, y )
	    EntityInflictDamage( owner, 0.0004, "DAMAGE_FALL", "ambient electricity", "NORMAL", 0, 0, owner, x, y, 0 )
	    EntityInflictDamage( owner, -0.0004, "DAMAGE_HEALING", "", "NONE", 0, 0, owner, x, y, 0 )

	    local index = Random( 1, #nearby_targets )
	    local target = nearby_targets[index]
	    -- skip self
	    while target == owner do
	        index = ( index % #nearby_targets ) + 1
	        target = nearby_targets[index]
	    end
	    local tx, ty = EntityGetTransform( target )
	    rdir_x = tx - x
	    rdir_y = ty - y
	    do_random = false

	    local proj_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/lightning_safe.xml", x, y )
	    local proj_comp = EntityGetFirstComponent( proj_id, "ProjectileComponent" )
	    if exists( proj_comp ) then
	    	ComponentSetValue2( proj_comp, "friendly_fire", false )
	    	ComponentSetValue2( proj_comp, "explosion_dont_damage_shooter", true )
			-- ComponentObjectSetValue2( proj_comp, "config_explosion", "dont_damage_this", owner )

			GameShootProjectile( owner, x, y, x+rdir_x, y+rdir_y, proj_id )
		end
	end
end

-- maybe zap a random nearby enemy
nearby_targets = EntityGetInRadiusWithTag( x, y, EFFECT_RADIUS * 2, "homing_target" )
if exists( nearby_targets ) and #nearby_targets >= 1 then
	local is_boost_active = get_internal_int( owner, "master_of_lightning_is_effect_active" ) > 0
	if ( is_boost_active and Random( 1, 3 ) == 3 ) or Random( 1, 10 ) == 10 then
		zap()
	end
end
