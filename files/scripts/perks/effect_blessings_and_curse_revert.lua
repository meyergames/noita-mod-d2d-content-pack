dofile_once( "data/scripts/lib/utilities.lua" )

-- local init_biome_name = getInternalVariableValue( get_player(), "")
-- local biome_name = BiomeMapGetName( x, y )
-- if not string.find( biome_name, "holy" ) then
local cached_value = get_internal_int( get_player(), "blurse_cached_perk_destroy_chance" )
GlobalsSetValue( "TEMPLE_PERK_DESTROY_CHANCE", cached_value )
-- end
