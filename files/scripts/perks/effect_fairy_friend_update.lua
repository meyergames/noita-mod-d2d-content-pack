dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local targets = EntityGetInRadiusWithTag( x, y, 300, "homing_target" )
if ( #targets > 0 ) then
    for i,target_id in ipairs(targets) do

        -- if the target is a fairy, make them side with the player
        if string.find( EntityGetName( target_id ), "fairy_" ) then
            GetGameEffectLoadTo( target_id, "CHARM", false )
            EntityAddTag( target_id, "fairy" )
        -- if the target is not a fairy, make them spawn one on death
        else
            local effect_id = get_internal_int( target_id, "fairy_friend_effect_id" )

            -- not sure why the polymorph check is in place, but Oprah's Youth did it for their Grave Worms mod so it must have a good reason?
            if effect_id == nil and not EntityHasTag( target_id, "polymorphed" ) then
                local lcomp = EntityAddComponent( target_id, "LuaComponent",
                {
                    script_death = "mods/D2DContentPack/files/scripts/perks/effect_fairy_friend_on_death.lua",
                    execute_every_n_frame = "-1",
                } )
                set_internal_int( target_id, "fairy_friend_effect_id", lcomp )
            end
        end
    end
end