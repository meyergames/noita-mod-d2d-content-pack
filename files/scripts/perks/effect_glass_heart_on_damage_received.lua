dofile_once( "data/scripts/lib/utilities.lua" )

local comp_id = GetUpdatedComponentID()
local owner = GetUpdatedEntityID()
local x, y = EntityGetTransform( owner )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local responsible_entity_tags = EntityGetTags( entity_thats_responsible )
    local responsible_entity_is_mortal = responsible_entity_tags and string.find( responsible_entity_tags, "mortal" )

    if damage > 0 then
		GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/damage", x, y )
		GamePrintImportant( "The Glass Heart shattered" )

        -- remove the effect's UI entity and all associated Lua scripts
        local ui_icon_id = get_child_by_filename( owner, "effect_glass_heart.xml" )
        if ui_icon_id then
            EntityKill( ui_icon_id )
        end
        remove_lua( owner, "d2d_glass_heart" )
	end
end