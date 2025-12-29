dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( proj_id )

local storage_id = EntityLoad( "mods/D2DContentPack/files/entities/projectiles/deck/glass_shard_bonus_dmg_storage.xml", x, y )
set_internal_float( storage_id, "d2d_glass_shard_bonus_dmg", get_internal_float( proj_id, "d2d_glass_shard_bonus_dmg" ) or 0 )
