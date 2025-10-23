dofile_once("data/scripts/lib/utilities.lua")

local CONVERT_RADIUS = 8

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )
local x,y = EntityGetTransform( owner )

local p_dcomp = EntityGetFirstComponentIncludingDisabled( owner, "DamageModelComponent" )
local p_hp = ComponentGetValue2( p_dcomp, "hp" )
local p_max_hp = ComponentGetValue2( p_dcomp, "max_hp" )

local cdatacomp = EntityGetFirstComponentIncludingDisabled( owner, "CharacterDataComponent" )
local is_on_ground = ComponentGetValue2( cdatacomp, "is_on_ground" )

local mccomp_1
local mccomp_2
local mccomp_3
local mccomps = EntityGetComponentIncludingDisabled( owner, "MagicConvertMaterialComponent" )
for i,mccomp in ipairs( mccomps ) do
	local to_mat = ComponentGetValue2( mccomp, "to_material" )
	local ignite = ComponentGetValue2( mccomp, "ignite_materials" )
	if to_mat == CellFactory_GetType( "lavarock_static" ) and ignite == 0 then
		mccomp_1 = mccomp
	elseif to_mat == CellFactory_GetType( "lavarock_static" ) and ignite == 100 then
		mccomp_2 = mccomp
	elseif to_mat == CellFactory_GetType( "lava" ) then
		mccomp_3 = mccomp
	end
end

local old_val = get_internal_int( owner, "d2d_floor_is_lava_counter" ) or 0
local counter = 0
local biome_name = BiomeMapGetName( x, y )
if is_on_ground and not string.find( biome_name, "holy" ) then
    counter = old_val + 1
else
	counter = math.max( old_val - 4, 0 )
end
set_internal_int( owner, "d2d_floor_is_lava_counter", counter )

if ( counter < 60 ) then
	ComponentSetValue2( mccomp_1, "radius", 0 )
	ComponentSetValue2( mccomp_2, "radius", 0 )
	ComponentSetValue2( mccomp_3, "radius", 0 )
elseif ( counter >= 60 and counter < 78 ) then
	ComponentSetValue2( mccomp_1, "radius", CONVERT_RADIUS )
	ComponentSetValue2( mccomp_2, "radius", 0 )
	ComponentSetValue2( mccomp_3, "radius", 0 )
elseif ( counter >= 78 and counter < 90 ) then
	ComponentSetValue2( mccomp_1, "radius", 0 )
	ComponentSetValue2( mccomp_2, "radius", CONVERT_RADIUS )
	ComponentSetValue2( mccomp_3, "radius", 0 )
elseif ( counter >= 90 ) then
	ComponentSetValue2( mccomp_1, "radius", 0 )
	ComponentSetValue2( mccomp_2, "radius", 0)
	ComponentSetValue2( mccomp_3, "radius", CONVERT_RADIUS )
end
