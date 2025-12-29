
local entity_id = GetUpdatedEntityID()
local audiocomp = EntityGetFirstComponent( entity_id, "AudioLoopComponent" )
if audiocomp then
	ComponentSetValue2( audiocomp, "m_volume", 0.2 )
end