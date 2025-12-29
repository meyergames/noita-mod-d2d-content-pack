local entity_id = GetUpdatedEntityID()
local target = EntityGetRootEntity(entity_id)
EntityGetTransform(target)

local c = EntityLoad("mods/D2DContentPack/files/entities/misc/status_effects/effect_heal_block_remove.xml", pos_x, pos_y)
EntityAddChild(target,c)
