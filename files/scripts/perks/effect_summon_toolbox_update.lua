dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local x, y = EntityGetTransform( GetUpdatedEntityID() )
local currbiome = BiomeMapGetName( x, y )
local flag = "toolbox_" .. tostring(currbiome) .. "_visited"

local prev_hm_count = tonumber( GlobalsGetValue( "D2D_TOOLBOX_PREV_HM_COUNT", "0" ) )
local curr_hm_count = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )

local is_new_hm = curr_hm_count > prev_hm_count
if is_new_hm then
	GlobalsSetValue( "D2D_TOOLBOX_PREV_HM_COUNT", tostring( curr_hm_count ) )
end

if not GameHasFlagRun( flag ) or ( is_new_hm and curr_hm_count > 1 ) then
	if generate_random_toolbox_spells( 1, true ) then
		GameAddFlagRun( flag )
	end
end
