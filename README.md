# LuaPatch

Lua patch is a utility tool for creating patch between two different Lua variables
with same type. This patch can then be applied to another variable. All number
values, expect table keys, will be caculate and result with a delta offset
within the patch. For string and boolean, values will be update with the
latest value, if there is no different between, patch returns as nil.

It provides three functions:

```lua
local lpatch = require "lpatch"
local clone = lpatch:copy (origin)
```

Shallow copy of the orginal table.

```lua
local lpatch = require "lpatch"
local patch = lpatch:make (origin, clone)
```

Make patch between two tables.

```lua
local lpatch = require "lpatch"
local patched = lpatch:apply (origin, patch)
```

Apply patch to old_table.

# Example
```lua
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
```

## Patch json layout

```json
{
    "@s#n":-1,
    "@s#dict":{
        "+s#b":"456"
    },
    "@s#s":"bbb",
    "@s#list":{
        "+n#2":"e2"
    },
    "@s#b":false
}
```

# License

Copyright © 2021-2023 Peng Yuan Wang <deflinhec@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
