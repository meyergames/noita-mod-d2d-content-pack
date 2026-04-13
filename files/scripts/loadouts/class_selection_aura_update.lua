dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local player = get_player()
local px, py = EntityGetTransform( get_player() )
local x, y = EntityGetTransform( GetUpdatedEntityID() )

local dist = get_magnitude( px - x, py - y)
if dist > 105 then
	local nearby_class_cards = EntityGetWithTag( "d2d_class_card" )
	if exists( nearby_class_cards ) then
		for i,card in ipairs( nearby_class_cards ) do
			EntityKill( card )
		end
		EntityKill( GetUpdatedEntityID() )
	end
end
