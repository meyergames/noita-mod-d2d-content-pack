dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local entity_id = GetUpdatedEntityID()
local x,y = EntityGetTransform( entity_id )
local r = 160

local targets = EntityGetInRadiusWithTag( x, y, r, "card_action" )

--Spells which can be converted
local input =  {
    "D2D_REWIND",
    "D2D_REWIND_ALT_FIRE",
    "D2D_MANA_REFILL",
    "D2D_MANA_REFILL_ALT_FIRE",
    "D2D_CONCRETE_WALL",
    "D2D_CONCRETE_WALL_ALT_FIRE",
    "D2D_BOLT_CATCHER",
    "D2D_BOLT_CATCHER_ALT_FIRE",

    "CHAINSAW",
    "D2D_RESET_CAST_DELAY",

    "D2D_RECYCLE",
    "D2D_SECOND_WIND",

    "D2D_MANA_SPLIT",
    "MANA_REDUCE",

    "D2D_UPGRADE_REMOVE_ALWAYS_CAST",
    "D2D_UPGRADE_PROMOTE_SPELL",

    "D2D_UPGRADE_MAX_MANA",
    "D2D_UPGRADE_MANA_CHARGE_SPEED",

    "D2D_DELTA",
    "D2D_PRISM",

    "ENERGY_SHIELD",
    "D2D_RELOAD_SHIELD",

    "D2D_FLURRY",
    "D2D_RAMP_UP",

    "D2D_REVEAL",
    "X_RAY",

    "D2D_SNIPE_SHOT",
    "D2D_SNIPE_SHOT_TRIGGER",

    "SINEWAVE",
    "D2D_HELIX_SHOT",

    "DAMAGE",
    "D2D_DAMAGE_MULT",

    "DAMAGE_FOREVER",
    "D2D_MISSING_MANA_TO_DMG",

    "D2D_CURSES_TO_DAMAGE",
    "D2D_CURSES_TO_MANA",

    "RECHARGE",
    "D2D_OVERCLOCK",

    "LIGHT_BULLET_TRIGGER",
    "D2D_GHOST_TRIGGER",
}

--Spells we're converting them into
--Position in this list correleations with their position in the input list
--"SPECIAL_ACTION" means something special should happen instead of just normal spell conversion
local output = {
    "D2D_REWIND_ALT_FIRE",
    "D2D_REWIND",
    "D2D_MANA_REFILL_ALT_FIRE",
    "D2D_MANA_REFILL",
    "D2D_CONCRETE_WALL_ALT_FIRE",
    "D2D_CONCRETE_WALL",
    "D2D_BOLT_CATCHER_ALT_FIRE",
    "D2D_BOLT_CATCHER",

    "D2D_RESET_CAST_DELAY",
    "CHAINSAW",

    "D2D_SECOND_WIND",
    "D2D_RECYCLE",

    "MANA_REDUCE",
    "D2D_MANA_SPLIT",

    "D2D_UPGRADE_PROMOTE_SPELL",
    "D2D_UPGRADE_REMOVE_ALWAYS_CAST",

    "D2D_UPGRADE_MANA_CHARGE_SPEED",
    "D2D_UPGRADE_MAX_MANA",

    "D2D_PRISM",
    "SPECIAL_ACTION",

    "D2D_RELOAD_SHIELD",
    "ENERGY_SHIELD",

    "D2D_RAMP_UP",
    "D2D_FLURRY",

    "X_RAY",
    "D2D_REVEAL",

    "D2D_SNIPE_SHOT_TRIGGER",
    "D2D_SNIPE_SHOT",

    "D2D_HELIX_SHOT",
    "SINEWAVE",
    
    "D2D_DAMAGE_MULT",
    "DAMAGE",

    "D2D_MISSING_MANA_TO_DMG",
    "DAMAGE_FOREVER",

    "D2D_CURSES_TO_MANA",
    "D2D_CURSES_TO_DAMAGE",

    "D2D_OVERCLOCK",
    "RECHARGE",

    "D2D_GHOST_TRIGGER",
    "LIGHT_BULLET_TRIGGER",
}

for k=1, #targets do
    local v = targets[k]
    if v ~= entity_id and EntityGetParent( v ) == 0 then	
        local comp = EntityGetFirstComponentIncludingDisabled( v, "ItemActionComponent" )
        for k=1, #input do
            if ComponentGetValue2( comp, "action_id" ) == input[k] then
                local spell_x, spell_y = EntityGetTransform( v )

                if output[k] == "SPECIAL_ACTION" then
                    if input[k] == "D2D_PRISM" and get_perk_pickup_count( "D2D_PRISM_KICK" ) < 3 then
                        spawn_perk( "D2D_PRISM_KICK", spell_x, spell_y - 8, true )

                        EntityLoad( "data/entities/particles/image_emitters/perk_effect.xml", spell_x, spell_y - 8 )
                        GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/chest/create", spell_x, spell_y - 8 )
                        GamePrintImportant( "A perk has appeared!", "" )
                    else
                        CreateItemActionEntity( "D2D_DELTA", spell_x, spell_y )
                    end
                    EntityKill( v )
                else
                    EntityKill( v )
                    CreateItemActionEntity( output[k], spell_x, spell_y )
                end
            end
        end
    end
end
