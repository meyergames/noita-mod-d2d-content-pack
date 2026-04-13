dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local NUM_CLASSES = 2

classes = {
	{
		id = "D2D_CLASS_SNIPER",
		function_name = "spawn_loadout_sniper",
		ui_name = "$loadout_d2d_sniper_name",
		ui_description = "$loadout_d2d_sniper_desc",
		sprite = "mods/D2DContentPack/files/gfx/ui_gfx/loadouts/sniper.png",
	},
	{
		id = "D2D_CLASS_TINKERER",
		function_name = "spawn_loadout_tinkerer",
		ui_name = "$loadout_d2d_tinkerer_name",
		ui_description = "$loadout_d2d_tinkerer_desc",
		sprite = "mods/D2DContentPack/files/gfx/ui_gfx/loadouts/tinkerer.png",
	},
}

-- this function was copied and adjusted from the Selectable Classes mod
function spawn_class_cards( start_x, start_y )
    --generate class pickups in rows
    for i=1, NUM_CLASSES do
        --load pickup
        local entity = EntityLoad( "mods/D2DContentPack/files/entities/misc/loadouts/class_card.xml", start_x + ( (i-1) * 40 ), start_y )
        if entity == nil then return end

        local class = classes[i]

        --setup components
        EntityAddComponent( entity, "SpriteComponent", { 
            image_file = class.sprite or "mods/D2DContentPack/files/gfx/ui_gfx/loadouts/template.png",  
            offset_x = "10",
            offset_y = "10",
            update_transform = "1",
            update_transform_rotation = "0",
        })
        EntityAddComponent( entity, "UIInfoComponent", { 
            name = class.ui_name,
        })
        EntityAddComponent( entity, "ItemComponent", { 
            item_name = GameTextGetTranslatedOrNot( class.ui_name ),
            ui_description = GameTextGetTranslatedOrNot( class.ui_description ) or "",
            play_spinning_animation = "0",
            play_hover_animation = "1",
            play_pick_sound = "0",
        })
        EntityAddComponent( entity, "SpriteOffsetAnimatorComponent", { 
            sprite_id="-1",
            x_amount="0",
            x_phase="0",
            x_phase_offset="0",
            x_speed="0",
            y_amount="2",
            y_speed="3",
        })
        EntityAddComponent( entity, "VariableStorageComponent", { 
            name = "class_id",
            value_string = class.id,
        })

        -- store the name of the function that initializes this class
        set_internal_string( entity, "d2d_class_function_name", class.function_name )
    end
end

local x, y = EntityGetTransform( get_player() )
spawn_class_cards( x - ( (NUM_CLASSES-1) * 20 ), y - 32 )
EntityLoad( "mods/D2DContentPack/files/entities/misc/loadouts/class_selection_aura.xml", x, y )

if not HasFlagPersistent( "d2d_class_loadouts_introduced" ) then
    EntityLoad( "mods/D2DContentPack/files/entities/misc/loadouts/book_instruction.xml", x+30, y-15 )
    AddFlagPersistent( "d2d_class_loadouts_introduced" )
end