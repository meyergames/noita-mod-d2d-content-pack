dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local owner = EntityGetRootEntity( entity_id )

local matconv_lavarock_id = EntityAddComponent2( owner, "MagicConvertMaterialComponent", 
{
	from_material_tag = "[solid]",
	to_material = CellFactory_GetType( "lavarock_static" ),
	is_circle = true,
	radius = 0,
	kill_when_finished = false,
} )
EntityAddTag( matconv_lavarock_id, "d2d_floor_is_lava_matconv_1" )

local matconv_lavarockburning_id = EntityAddComponent2( owner, "MagicConvertMaterialComponent", 
{
	from_material_tag = "[solid]",
	to_material = CellFactory_GetType( "lavarock_static" ),
	is_circle = true,
	radius = 0,
	ignite_materials = 100,
	kill_when_finished = false,
} )
EntityAddTag( matconv_lavarock_id, "d2d_floor_is_lava_matconv_2" )

local matconv_lava_id = EntityAddComponent2( owner, "MagicConvertMaterialComponent", 
{
	from_material_tag = "[solid]",
	to_material = CellFactory_GetType( "lava" ),
	is_circle = true,
	radius = 0,
	kill_when_finished = false,
} )
EntityAddTag( matconv_lavarock_id, "d2d_floor_is_lava_matconv_3" )
