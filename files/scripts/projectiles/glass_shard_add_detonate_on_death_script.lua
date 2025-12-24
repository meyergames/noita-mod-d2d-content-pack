dofile_once( "data/scripts/lib/utilities.lua" )

local shard_entity = GetUpdatedEntityID()
local x, y = EntityGetTransform( shard_entity )

-- local owner = EntityGetRoot( shard_entity )
local owner = EntityGetInRadiusWithTag( x, y, 3, "homing_target" )[1]
if owner and owner ~= 0 then
    EntityAddComponent2( owner, "LuaComponent",
    {
        script_death = "mods/D2DContentPack/files/scripts/projectiles/glass_shard_detonate_on_death.lua",
        execute_every_n_frame = -1,
    } )
end
