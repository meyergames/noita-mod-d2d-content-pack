dofile_once( "data/scripts/lib/utilities.lua" )
local EZWand = dofile_once("mods/D2DContentPack/files/scripts/lib/ezwand.lua")

local player = get_player()
local wand_to_save

local children = EntityGetAllChildren( player )
if not children then return end

for k=1,#children do
	child = children[k]
    if EntityGetName( child ) == "inventory_quick" then
        local inventory_items = EntityGetAllChildren(child)
        if inventory_items ~= nil then
            for z=1, #inventory_items do
            	item = inventory_items[z]

                if item and item ~= 0 and EZWand.IsWand( item ) then
                	local wand = EZWand( item )

                	local name, show_name_in_ui = wand:GetName()
                	if string.find( name, "Remembrance" ) then
                		wand_to_save = wand
                	end
                end
            end 
        end
    end 
end

if wand_to_save then
	local spells, always_casts = wand_to_save:GetSpells()

	local csv = ""
	-- for i,spell in ipairs( always_casts ) do
	-- 	csv = csv .. spell.action_id .. ","
	-- end
	-- csv = csv .. "\n"
	for i,spell in ipairs( spells ) do
		csv = csv .. spell.action_id .. ","
	end

    ModSettingSet( "D2DContentPack.som_stored_spells", csv )
end
