dofile_once( "mods/D2DContentPack/files/scripts/d2d_utils.lua" )

local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")
local entity_id = GetUpdatedEntityID()
local root = EntityGetRootEntity(entity_id)
local wand = EZWand(EntityGetParent(entity_id))
local x, y = EntityGetTransform(entity_id)
local controlscomp = EntityGetFirstComponent(root, "ControlsComponent")
local actionid = "action_d2d_hue_shift_mid_fire"
local cooldown_frames = 15
local cooldown_frame = get_internal_int( entity_id, "cooldown_frame" )
if not cooldown_frame then
	set_internal_int( entity_id, "cooldown_frame", 0 )
end

local children = EntityGetAllChildren( get_player() )
local inventory
local inventory_items
for k=1,#children do
    child = children[k]
    if EntityGetName( child ) == "inventory_full" then
        inventory = child
        inventory_items = EntityGetAllChildren( inventory )
    end
end

function try_drop_and_cache_spell( new_inv_x, card )
	if not exists( card ) then
		set_internal_int( entity_id, "cached_spell_" .. new_inv_x, -1 )
	end

	EntityRemoveFromParent( card )
	EntitySetTransform( card, x, y - 3, 0, 1, 1 )
	EntitySetComponentsWithTagEnabled( card, "enabled_in_inventory", false )
	EntitySetComponentsWithTagEnabled( card, "enabled_in_world", true )
    EntitySetComponentsWithTagEnabled( card, "item_unidentified", false )

	set_internal_int( entity_id, "cached_spell_" .. new_inv_x, card )

	-- local ia_comp = EntityGetFirstComponentIncludingDisabled( card, "ItemActionComponent" )
	-- if ia_comp then
	-- 	local action_id = ComponentGetValue2( ia_comp, "action_id" )
	-- 	set_internal_string( entity_id, "cached_spell_" .. index, action_id )
	-- 	GamePrint( "cached_spell_" .. index .. " set to " .. action_id )
	-- end
end

function try_pick_up_spell( card )
	if not exists( card ) then return end

	GamePickUpInventoryItem( get_player(), card, false )
	EntitySetComponentsWithTagEnabled( card, "enabled_in_inventory", true )
	EntitySetComponentsWithTagEnabled( card, "enabled_in_world", false )
end

if get_internal_bool( entity_id, "were_spells_dropped" ) and GameGetFrameNum() >= cooldown_frame - cooldown_frames + 1 then
 	local new_card_1 = get_internal_int( entity_id, "cached_spell_1" )
 	local new_card_2 = get_internal_int( entity_id, "cached_spell_2" )
 	local new_card_3 = get_internal_int( entity_id, "cached_spell_3" )
 	try_pick_up_spell( new_card_1 )
 	try_pick_up_spell( new_card_2 )
 	try_pick_up_spell( new_card_3 )

    set_internal_bool( entity_id, "were_spells_dropped", false )

    local first_spell = new_card_1
    local ia_comp = EntityGetFirstComponentIncludingDisabled( first_spell, "ItemActionComponent" )
    if ia_comp then
        local data = get_actions_lua_data( ComponentGetValue2( ia_comp, "action_id" ) )
        GamePlaySound("data/audio/Desktop/ui.bank", "ui/item_switch_places", x, y )
        GamePrint( "Hue Shift: " .. GameTextGetTranslatedOrNot( data.name ) )
    end
    
	local inv2_comp = EntityGetFirstComponentIncludingDisabled( get_player(), "Inventory2Component" )
	if inv2_comp then
		ComponentSetValue2( inv2_comp, "mForceRefresh", true )
	end
end

function get_card_at_inv_slot( x )
	for i,card in ipairs( inventory_items ) do
    	local itemcomp = EntityGetFirstComponentIncludingDisabled( card, "ItemComponent" )
    	if itemcomp then
    		local inv_x, inv_y = ComponentGetValue2( itemcomp, "inventory_slot" )
    		if inv_x == x-1 then -- index starts at 0 here since it's a vector
    			return card
    		end
    	end
	end
	return nil
end

if is_mid_fire_pressed() and GameGetFrameNum() >= cooldown_frame then
	set_internal_int( entity_id, "cooldown_frame", GameGetFrameNum() + cooldown_frames )

    if inventory_items ~= nil then
        local card_1 = get_card_at_inv_slot( 1 )
        local card_2 = get_card_at_inv_slot( 2 )
        local card_3 = get_card_at_inv_slot( 3 )

        try_drop_and_cache_spell( 3, card_1 )
        try_drop_and_cache_spell( 1, card_2 )
        try_drop_and_cache_spell( 2, card_3 )
    	set_internal_bool( entity_id, "were_spells_dropped", true )
    end
end