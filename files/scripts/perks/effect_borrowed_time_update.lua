dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player = EntityGetParent( GetUpdatedEntityID() )
local x, y = EntityGetTransform( player )

local stored_dmg = get_internal_float( player, "d2d_borrowed_time_stored_dmg" )
if exists( stored_dmg ) and stored_dmg > 0 then
	local dmg_comp = EntityGetFirstComponentIncludingDisabled( player, "DamageModelComponent" )
	if exists( dmg_comp ) then
		local hp = ComponentGetValue2( dmg_comp, "hp" )
		local max_hp = ComponentGetValue2( dmg_comp, "max_hp" )
		local dmg = math.min( stored_dmg, max_hp * 0.02 )
		-- local dmg = math.min( stored_dmg, ( max_hp * 0.02 ) + ( stored_dmg * 0.25 ) )

		EntityInflictDamage( player, dmg, "NONE", "borrowed time", "NONE", 0, 0, GetUpdatedEntityID(), x, y, 0 )
		-- deduct from remaining stored damage
		raise_internal_float( player, "d2d_borrowed_time_stored_dmg", -dmg )

		if get_internal_float( player, "d2d_borrowed_time_stored_dmg" ) <= 0 then
			GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/regeneration/tick", x, y )
		end
	end
end
