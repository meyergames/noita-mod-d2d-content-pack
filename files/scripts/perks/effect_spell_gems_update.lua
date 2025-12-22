dofile_once("data/scripts/lib/utilities.lua")

local MAX_EFFECT_DISTANCE = 100

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local spawned_creatures = EntityGetWithTag( "homing_target" )
if #spawned_creatures > 0 then
    for i,creature_id in ipairs( spawned_creatures ) do
    	if not has_lua( creature_id, "d2d_maybe_drop_spell_gem" ) then
    		EntityAddComponent2( creature_id, "LuaComponent", 
			{ 
				script_death = "mods/D2DContentPack/files/scripts/perks/effect_spell_gems_creature_death.lua",
				execute_every_n_frame = -1,
			} )	
    	end
    end
end
