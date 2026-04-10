dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local spawned_creatures = EntityGetWithTag( "homing_target" )
if #spawned_creatures > 0 then
    for i,creature_id in ipairs( spawned_creatures ) do
    	if not get_internal_bool( creature_id, "d2d_leech_life_effect_added" ) then

            -- check if enemy bleeds something organic
            -- if the enemy doesn't drop gold, it doesn't drop bubbles
            local e_dcomp = EntityGetFirstComponentIncludingDisabled( creature_id, "DamageModelComponent" )
            if exists( e_dcomp ) and not has_vscomp( entity_id, "no_gold_drop" ) then
                local blood_mat = ComponentGetValue2( e_dcomp, "blood_material" )
                local enemy_is_organic = string.find( blood_mat, "blood" ) or string.find( blood_mat, "slime" ) or string.find( blood_mat, "sludge" )
                local blood_mtp = ComponentGetValue2( e_dcomp, "blood_multiplier" )
                if enemy_is_organic and blood_mtp > 0 then
                    EntityAddComponent2( creature_id, "LuaComponent",
                    {
                        script_source_file = "mods/D2DContentPack/files/scripts/perks/effect_leech_life_creature_death.lua",
                        execute_every_n_frame = -1,
                        execute_on_removed = true,
                    } )
                    set_internal_bool( creature_id, "d2d_leech_life_effect_added", true )
                end
            end
    	end
    end
end
