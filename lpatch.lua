local type = type
local pairs = pairs
local table = table
local next = next
------------------------------------------------------------------//
-- Duplicate excatly same table/value the orginal
local function copy(_, orig)
    local orig_type = type(orig)
    local clone
    if orig_type == 'table' then
        clone = {}
        for orig_key, orig_value in pairs(orig) do
            clone[orig_key] = copy(_, orig_value)
        end
    else -- number, string, boolean, etc
        clone = orig
    end
    return clone
end
------------------------------------------------------------------//
local function tdiff(a, b)
    local d = {}
    local k, v = next(a)
    while k and v do
        if b[k] == nil then
            d[k]=v
        end
        k, v = next(a, k)
    end
    return d
end
------------------------------------------------------------------//
local function trait(pattern, k)
    if type(pattern) ~= "nil" then
        return pattern[k] or pattern[1]
    end
    return nil
end
------------------------------------------------------------------//
-- Cacluate difference between two table/value
local function make(_, orig, another, pattern)
    local diff
    if type(orig) ~= type(another) then
        return diff
    elseif type(orig) == type(another) then
        if type(orig) == "table" then
            for k, _ in pairs(pattern or orig) do
                local p = trait(pattern, k)
                local o, n = orig[k], another[k]
                local v = make(_, o, n, p)
                if type(v) ~= "function" then
                    if type(v) ~= "nil" then
                        diff = diff or {}
                        local t = type(k):sub(0,1)
                        diff["@"..t.."#"..k] = v
                    end
                end
            end
            -- another = mask(another, pattern or another)
            for k, v in pairs(tdiff(another, orig))  do
                if type(v) ~= "function" then
                    if type(pattern) == "nil" or
                        type(trait(pattern, k)) ~= "nil" then
                        diff = diff or {}
                        local t = type(k):sub(0,1)
                        diff["+"..t.."#"..k] = v
                    end
                end
            end
            for k, v in pairs(tdiff(orig, another))  do
                if type(v) ~= "function" then
                    if type(pattern) == "nil" or
                        type(trait(pattern, k)) ~= "nil" then
                        diff = diff or {}
                        local t = type(k):sub(0,1)
                        diff["-"..t.."#"..k] = v
                    end
                end
            end
        elseif another ~= orig then
            if type(orig) == "number" then
                diff = another - orig
            elseif type(orig) == "string" then
                diff = another
            elseif type(orig) == "boolean" then
                diff = another
            end
        end
    end
    return diff
end
------------------------------------------------------------------//
-- Apply patch to original table/value
local function apply(_, orig, patch)
    if type(orig) ~= type(patch) then
        return orig
    else
        orig = copy(_, orig)
        if type(patch) == "table" then
            local add, sub = {}, {}
            for k, v in pairs(patch) do
                if type(k) == "string" then
                    if k:sub(0,1) == "@" then
                        local ty, _k = k:sub(2,2), k:sub(4)
                        local cast = ty == "n" and tonumber or tostring
                        orig[cast(_k)] = apply(_, orig[cast(_k)], v)
                    elseif k:sub(3,3) == "#" then
                        local op, ty = k:sub(1,1), k:sub(2,2)
                        local list = op == "+" and add or sub
                        local cast = ty == "n" and tonumber or tostring
                        table.insert(list, {cast(k:sub(4)),v})
                    else
                        error("invalid patch format", 1)
                    end
                else
                    error("invalid patch format", 2)
                end
            end
            for _, tuple in pairs(add) do
                orig[tuple[1]] = tuple[2]
            end
            for _, tuple in pairs(sub) do
                orig[tuple[1]] = nil
            end
        elseif type(patch) == "number" then
            orig = orig + patch
        elseif type(patch) == "string" then
            orig = patch
        elseif type(patch) == "boolean" then
            orig = patch
        end
    end
    return orig
end
------------------------------------------------------------------//
return {make = make, apply = apply, copy = copy}