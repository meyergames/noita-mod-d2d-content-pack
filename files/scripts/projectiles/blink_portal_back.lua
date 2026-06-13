dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
if not exists( entity_id ) then return end
local x, y = EntityGetTransform( entity_id )

local nearby_player_units = EntityGetInRadiusWithTag( x, y, 35, "player_unit" )
if exists( nearby_player_units ) then
	for i,player_unit in ipairs( nearby_player_units ) do
		local x = get_internal_int( player_unit, "d2d_blink_origin_x" )
		local y = get_internal_int( player_unit, "d2d_blink_origin_y" )

		EntityApplyTransform( player_unit, x, y )
		GamePlaySound( "data/audio/Desktop/projectiles.bank", "player_projectiles/teleport/destroy", x, y )
        EntityInflictDamage( player_unit, 0.4, "DAMAGE_ELECTRICITY", "blink accident", "ELECTROCUTION", 0, 0, player_unit, x, y, 0)
	end
end

