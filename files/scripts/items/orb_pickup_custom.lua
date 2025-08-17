local old_item_pickup = item_pickup

item_pickup = function( entity_item, entity_who_picked, name )
    old_item_pickup( entity_item, entity_who_picked, name )

--    local virus_entity_id = GameGetGameEffect( entity_who_picked, "CUSTOM" )
--    local custom_effect_id = ComponentGetValue2( virus_entity_id, "custom_effect_id" )
--    if ( custom_effect_id == "VIRAL_INFECTION" or custom_effect_id == "VIRAL_INFECTION_WEAK" ) then
--        GamePrintImportant("The virus has been cured completely")
--    end

    EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION" )
--    EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION_WEAK" ) <--- this doesn't work because of the effect_permanent parameter :(

    --GamePrintImportant("The virus has been cured completely") -- this is only true for the VIRAL_INFECTION_WEAK that would be caused by this removal
end

--local old_item_pickup = item_pickup
--
--item_pickup = function( entity_item, entity_who_picked, name )
--    local custom_comps = EntityGetComponent( entity_who_picked, "GameEffectComponent" )
--    for i,comp in ipairs(custom_comps) do
--        local custom_effect_id = ComponentGetValue2( virus_entity_id, "custom_effect_id" )
--        if ( custom_effect_id ~= nil ) then
--            if ( custom_effect_id == "VIRAL_INFECTION" ) then
--                GamePrintImportant("The virus has been cured", "More or less...")
--                EntityRemoveComponent( entity_who_picked, custom_effect_id )
--                EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION" )
--            elseif ( custom_effect_id == "VIRAL_INFECTION_WEAK" ) then
--                GamePrintImportant("The virus has been cured completely")
--                EntityRemoveComponent( entity_who_picked, custom_effect_id )
--                EntityRemoveIngestionStatusEffect( entity_who_picked, "VIRAL_INFECTION_WEAK" )
--            end
--        end
--    end
--
--    old_item_pickup( entity_item, entity_who_picked, name )
--end



--	TODO: got this from the official potion.lua script. who knows this might work to loop through GameEffectComponents?
--
--	local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
--	if( components ~= nil ) then
--		for key,comp_id in pairs(components) do 
--			local var_name = ComponentGetValue( comp_id, "name" )
--			if( var_name == "potion_material") then
--				potion_material = ComponentGetValue( comp_id, "value_string" )
--			end
--		end
--	end
