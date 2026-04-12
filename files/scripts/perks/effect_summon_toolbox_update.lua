dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local currbiome = BiomeMapGetName( x, y )
local flag = "toolbox_" .. tostring(currbiome) .. "_visited"

if not GameHasFlagRun( flag ) then
	if generate_random_toolbox_spells( 1, true ) then
		GameAddFlagRun( flag )
	end
end
