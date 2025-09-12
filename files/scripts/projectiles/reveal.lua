dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
pos_y = pos_y - 4 -- offset to middle of character

local range = 500
local indicator_distance = 24

local function ping( id )
	local obj_x, obj_y = EntityGetTransform(id)

	local dir_x = obj_x - pos_x
	local dir_y = obj_y - pos_y
	local distance = get_magnitude(dir_x, dir_y)

	-- sprite positions around character
	dir_x, dir_y = vec_normalize(dir_x,dir_y)
	local indicator_x = pos_x + dir_x * indicator_distance
	local indicator_y = pos_y + dir_y * indicator_distance

	-- display sprite based on proximity
	if distance > range * 0.5 then
		GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_cursed_chest_faint.png", indicator_x, indicator_y )
	elseif distance > range * 0.25 then
		GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_cursed_chest_medium.png", indicator_x, indicator_y )
	elseif distance > 10 then
		GameCreateSpriteForXFrames( "mods/D2DContentPack/files/particles/radar_cursed_chest_strong.png", indicator_x, indicator_y )
	end
end

-- ping nearby items and wands
for _,id in pairs( EntityGetInRadiusWithTag( pos_x, pos_y, range, "item_pickup" ) ) do
	local parent = EntityGetRootEntity( id )

	if( IsPlayer( parent ) == false ) then
		ping( id )
	end
end
