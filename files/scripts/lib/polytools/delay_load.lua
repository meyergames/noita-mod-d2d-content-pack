dofile_once("mods/D2DContentPack/files/scripts/lib/polytools/disco_util/disco_util.lua")
local polytools = dofile_once("mods/D2DContentPack/files/scripts/lib/polytools/polytools.lua")
local self = Entity.Current()
polytools.load(self, self.var_str.polydata)
