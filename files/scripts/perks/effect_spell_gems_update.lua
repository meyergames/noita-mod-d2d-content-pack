dofile_once("data/scripts/lib/utilities.lua")

local MAX_EFFECT_DISTANCE = 100

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local spawned_creatures = EntityGetWithTag( "homing_target" )
if #spawned_creatures > 0 then
    for i,creature_id in ipairs( spawned_creatures ) do
    	if not get_internal_bool( creature_id, "d2d_spell_gems_effect_added" ) then
    		EntityAddComponent2( creature_id, "LuaComponent",
			{
				script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_spell_gems_creature_death.lua",
				execute_every_n_frame = -1,
				execute_on_removed = true,
			} )
			set_internal_bool( creature_id, "d2d_spell_gems_effect_added", true )
    	end
    end
end
