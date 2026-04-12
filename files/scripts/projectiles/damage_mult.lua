dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local proj_id = GetUpdatedEntityID()

-- multiply the projectile's damage by x1.5, including modifiers
multiply_proj_dmg( proj_id, 1.5 )
