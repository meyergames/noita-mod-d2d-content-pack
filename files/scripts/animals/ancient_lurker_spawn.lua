dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

set_internal_int( entity_id, "d2d_ancient_lurker_phase", 1 )
change_materials_that_damage( owner, { material_darkness = -0.0001 })
