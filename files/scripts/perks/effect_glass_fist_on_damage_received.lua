dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local comp_id = GetUpdatedComponentID()
local owner = GetUpdatedEntityID()
local x, y = EntityGetTransform( owner )

function damage_received( damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible )
	local responsible_entity_tags = EntityGetTags( entity_thats_responsible )
    local responsible_entity_is_mortal = responsible_entity_tags and string.find( responsible_entity_tags, "mortal" )

    if damage > 0 and get_internal_bool( owner, "d2d_glass_fist_boost_enabled" ) then
        set_internal_bool( owner, "d2d_glass_fist_boost_enabled", false )
        
		GamePlaySound( "data/audio/Desktop/misc.bank", "game_effect/frozen/damage", x, y )
		GamePrint( "Glass Fist's damage boost has ended" )

        -- remove the effect's UI entity
        local ui_icon_id = get_child_with_name( owner, "glass_fist_overhead_icon.xml" )
        if ui_icon_id then
            EntityKill( ui_icon_id )
        end
	end
end