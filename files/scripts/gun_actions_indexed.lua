local indexed_gun_actions = {}
dofile_once("data/scripts/gun/gun_actions.lua")
for _, action in ipairs(actions or {}) do
    indexed_gun_actions[action.id or "NULL"] = action
end

return indexed_gun_actions