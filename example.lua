local print = print
local assert = assert
local utils = require 'utils'
local json = require 'dkjson'
local lpatch = require 'lpatch'

local origin = {
    n = 1.1,
    b = true,
    s = "aaa",
    list = {
        "e1",
    },
    dict = {
        a = "123",
    },
}

-- Make some change to table
local modified = lpatch:copy(origin)
table.insert(modified.list, "e2")
modified.n = modified.n - 1
modified.dict.b = "456"
modified.s = "bbb"
modified.b = false

-- Make patch and apply
local patch = lpatch:make(origin, modified)
local patched = lpatch:apply(origin, patch)
assert(utils:deepcompare(modified, patched))

print(json.encode(patch, {indent = true}))
print(json.encode(origin, {indent = true}))
print(json.encode(patched, {indent = true}))