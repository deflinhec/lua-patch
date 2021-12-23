-----------------------------------------------------------------------//
-- unit test extension
-----------------------------------------------------------------------//
local say = require 'say'
local assert = require 'luassert'
local utils = require 'utils'
local unpack = unpack
----------------------------------------------------------------//
local function deep_equal(state, arguments)
    if #arguments ~= 2 then
        return false
    end
    return utils:deepcompare(unpack(arguments))
end
say:set("assertion.deep_equal.positive", "Expected %s \nequal to: %s")
say:set("assertion.deep_equal.negative", "Expected %s \nequal to: %s")
assert:register("assertion", "deep_equal", deep_equal, "assertion.deep_equal.positive", "assertion.deep_equal.negative")
----------------------------------------------------------------//