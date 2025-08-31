dofile_once("data/scripts/lib/utilities.lua")

--local entity_id = GetUpdatedEntityID()
--local owner = EntityGetParent(entity_id)
local player = get_player()

if ( getInternalVariableValue( player, "ring_of_life_triggered", "value_int" ) == 1 ) then return end
-- if the effect triggered before, cancel this script



local dcomp = EntityGetFirstComponentIncludingDisabled( player, "DamageModelComponent" )
local player_hp = ComponentGetValue2( dcomp, "hp" )
local player_max_hp = ComponentGetValue2( dcomp, "max_hp" )

if ( player_hp <= player_max_hp * 0.1 ) then
    local x, y = EntityGetTransform( player )
    local tpx, tpy = 0,0
    local hm_visits = tonumber( GlobalsGetValue( "HOLY_MOUNTAIN_VISITS", "0" ) )

    if ( hm_visits == 0 ) then
        tpx, tpy = 277, -84
    elseif( hm_visits == 1 and y > 1390 ) then
        tpx, tpy = -497, 1350
    elseif ( hm_visits == 2 and y > 2930 ) then
        tpx, tpy = -497, 2890
    elseif ( hm_visits == 3 and y > 4980 ) then
        tpx, tpy = -497, 4940
    elseif ( hm_visits == 4 and y > 6520 ) then
        tpx, tpy = -497, 6480
    elseif ( hm_visits == 5 and y > 8570 ) then
        tpx, tpy = -497, 8530
    elseif ( hm_visits == 6 and y > 10610 ) then
        tpx, tpy = -497, 10570
    elseif ( y > 12500 ) then
        tpx, tpy = 2170, 13230
    else
        tpx, tpy = 770, -823
    end
    EntitySetTransform( player, tpx, tpy )

    setInternalVariableValue( player, "ring_of_life_triggered", "value_int", 1 )
    GamePlaySound( "data/audio/Desktop/materials.bank", "collision/glass_potion/destroy", x, y )
    GamePrint( "The Ring of Life brings you back to safety, but shatters in the process." )

    remove_perk( "D2D_RING_OF_LIFE" )
    pickup_count = tonumber( GlobalsGetValue( "D2D_RING_OF_LIFE_PICKUP_COUNT", "0" ) )

    if ( pickup_count == 0 ) then
        EntityAddComponent2( player, "UIIconComponent",
        {
            name = "Ring Of Life (shattered)",
            description = "It's of no use now.",
            icon_sprite_file = "mods/RiskRewardBundle/files/gfx/ui_gfx/perks/ring_of_life_016_spent.png",
            display_above_head = false,
            display_in_hud = true,
            is_perk = true,
        })
    end
end
