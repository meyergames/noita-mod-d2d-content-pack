dofile_once("mods/D2DContentPack/files/scripts/lib/polytools/disco_util/disco_util.lua")

local self = Entity.Current()
if self.ProjectileComponent then self.ProjectileComponent.on_death_explode = true end
