dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()

-- multiply the projectile's damage by x2.0, including modifiers
multiply_proj_dmg_by_type( proj_id, "electricity", 2.0, "master_of_lightning" )
