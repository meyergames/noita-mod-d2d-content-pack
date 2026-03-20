do
    ---@type metatable
    local old_mt = getmetatable(_G) or {}
    local function index(self, key)
        if old_mt.__index then
            if type(old_mt.__index) == "table" then
                return old_mt.__index[key]
            elseif type(old_mt.__index) == "function" then
                return old_mt.__index(self, key)
            end
        end
    end
    local function newindex(self, key, value)
        if old_mt.__newindex then
            if type(old_mt.__newindex) == "table" then
                old_mt.__newindex[key] = value
            elseif type(old_mt.__index) == "function" then
                old_mt.__newindex(self, key, value)
            end
        end
    end
    ---@type number
    local mana = nil
    ---@type metatable
    local mt = {
        __index = function(self, key)
            print("__index", key)
            if key == "mana" then
                return mana
            end
            return index(self, key)
        end,
        __newindex = function(self, key, value)
            print("__newindex", key, value)
            if key == "mana" then
                if not mana then
                    mana = value
                end
                ---@type number
                local delta = mana - value
                delta = delta / 10
                ---@type number
                mana = mana - delta
            end
            newindex(self, key, value)
        end,
    }
    setmetatable(_G, mt)
end

mana = 100
print(mana)
mana = 0
print(mana)


-- TODO: actually append gun.lua with this
-- 
-- NOTES FROM NATHAN:
-- 
-- works
-- might break horribly
-- also makes luals cry
-- __index is the function that gets called when you get an index from a table, __newindex when you set an index in a table
-- setmetatable sets the metatable for the table
-- also make sure to nil out mana
-- if the key is already in the table the metamethods arent called
-- so here i redefine what it means to create a global called mana to instead assign to the local mana with 1/10th of the difference between the new value and the locals value
-- 
-- more info: search the Noita discord server for "also makes luals cry from:Nathan"