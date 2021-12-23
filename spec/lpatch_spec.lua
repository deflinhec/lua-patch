require 'spec.extensions'
local json = require 'dkjson'
-----------------------------------------------------------------------//
-- TestModule
-----------------------------------------------------------------------//
describe("Patch module", function()
    local Patch = {}
    setup(function ()
        Patch = require("lpatch")
    end)
    it("number key insert should apply to table", function()
        local origin = {
            [1] = 2
        }

        local modified = Patch:copy(origin)
        modified[99] = 100

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("number key remove should apply to table", function()
        local origin = {
            [1] = 2,
            [99] = 100,
        }

        local modified = Patch:copy(origin)
        modified[99] = nil

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("mixture key insert should apply to table", function()
        local origin = {
            [99] = 2,
        }

        local modified = Patch:copy(origin)
        modified.first = 3

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("mixture key remove should apply to table", function()
        local origin = {
            [99] = 2,
            first = 3,
        }

        local modified = Patch:copy(origin)
        modified.first = nil

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("function key should be ignore during patch", function()
        local origin = {
            [99] = 2,
        }

        local modified = Patch:copy(origin)
        modified.func = function() end

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.falsy(patch)
        assert.is.not_deep_equal(patched, modified)
    end)
    it("boolean update should apply to table", function()
        local origin = {
            first = true
        }

        local modified = Patch:copy(origin)
        modified.first = false

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("string update should apply to table", function()
        local origin = {
            first = "origin"
        }

        local modified = Patch:copy(origin)
        modified.first = "updated"

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("value increase should apply to table", function()
        local origin = {
            first = 1
        }

        local modified = Patch:copy(origin)
        modified.first = modified.first + 1

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("value decrease should apply to table", function()
        local origin = {
            first = 1
        }

        local modified = Patch:copy(origin)
        modified.first = modified.first - 1

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("value increase with depth of 2 should apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            }
        }

        local modified = Patch:copy(origin)
        for i, pool in pairs(modified.pools) do
            pool.accumulate = pool.accumulate + i
        end

        local patch = Patch:make(origin, modified, {
            pools = {
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("value decrease with depth of 2 should apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            }
        }

        local modified = Patch:copy(origin)
        for i, pool in pairs(modified.pools) do
            pool.accumulate = pool.accumulate - i
        end

        local patch = Patch:make(origin, modified, {
            pools = {
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("key update should apply to table", function()
        local origin = {
            second = 2
        }
        local modified = Patch:copy(origin)
        modified.second = 1

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("key update should apply to table", function()
        local origin = {
            second = 2
        }
        local modified = Patch:copy(origin)
        modified.second = 1

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("key insert should apply to table", function()
        local origin = {}
        local modified = Patch:copy(origin)
        modified.second = 2

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("key remove should apply to table", function()
        local origin = {
            fisrt = 1,
        }
        local modified = Patch:copy(origin)
        modified.fisrt = nil

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("key insert with depth of 2 should apply to table", function()
        local origin = {
            pools = {
                fisrt = 1,
            },
        }
        local modified = Patch:copy(origin)
        modified.pools.second = 2

        local patch = Patch:make(origin, modified, {
            pools = {
                first = 0,
                second = 0,
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("key remove with depth of 2 should apply to table", function()
        local origin = {
            pools = {
                fisrt = 1,
                second = 2,
            },
        }
        local modified = Patch:copy(origin)
        modified.pools.second = nil

        local patch = Patch:make(origin, modified, {
            pools = {
                fisrt = 1,
                second = 2,
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element update should apply to table", function()
        local origin = {
            0,0,0,0
        }
        local modified = Patch:copy(origin)
        modified[2] = modified[2] + 5

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("elements update should apply to table", function()
        local origin = {
            0,0,0,0
        }
        local modified = Patch:copy(origin)
        for i, _ in ipairs(modified) do
            modified[1] = modified[1] + i
        end

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element insert should apply to table", function()
        local origin = {
            'abc', 'bcd', 'efg'
        }
        local modified = Patch:copy(origin)
        table.insert(modified, 'hij')

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element inserts should apply to table", function()
        local origin = {
            'abc', 'bcd', 'efg'
        }
        local modified = Patch:copy(origin)
        table.insert(modified, 'hij')
        table.insert(modified, 'lmn')

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element remove should apply to table", function()
        local origin = {
            'abc', 'bcd', 'efg'
        }
        local modified = Patch:copy(origin)
        table.insert(modified, 1)

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element removes should apply to table", function()
        local origin = {
            'abc', 'bcd', 'efg'
        }
        local modified = Patch:copy(origin)
        table.insert(modified, 1)
        table.insert(modified, #modified)

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element clear should apply to table", function()
        local origin = {
            'abc', 'bcd', 'efg'
        }
        local modified = Patch:copy(origin)
        modified = {}

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element assign should apply to table", function()
        local origin = {
            'abc', 'bcd', 'efg'
        }
        local modified = Patch:copy(origin)
        modified = {'hij', 'lmn'}

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element insert with depth of 2 should apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            },
        }
        local modified = Patch:copy(origin)
        table.insert(modified.pools, {accumulate=130})

        local patch = Patch:make(origin, modified, {
            pools = {
                {accumulate=100,frontend=1300,test=2},
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("element remove with depth of 2 should apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            },
        }
        local modified = Patch:copy(origin)
        table.remove(modified.pools, 2)

        local patch = Patch:make(origin, modified, {
            pools = {
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
                {accumulate=0,frontend=0},
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("changeset not inclued in pattern should not apply to table", function()
        local origin = {
            first = "first"
        }
        local modified = Patch:copy(origin)
        modified.second = "second"

        local patch = Patch:make(origin, modified, {
            first = "",
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, origin)
        assert.is.not_deep_equal(patched, modified)
    end)
    it("changeset with depth of 2 not inclued in pattern should not apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            },
        }
        local modified = Patch:copy(origin)
        for i, pool in pairs(modified.pools) do
            pool.test = pool.test - i
        end

        local patch = Patch:make(origin, modified, {
            pools = {
                {accumulate=0,frontend=0},
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, origin)
        assert.is.not_deep_equal(patched, modified)
    end)
    it("changeset with depth of 2 not include in pattern should not apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            },
        }
        local modified = Patch:copy(origin)
        for i, pool in pairs(modified.pools) do
            pool.test = pool.test - i
        end

        local patch = Patch:make(origin, modified, {
            pools = {
                {accumulate=0,frontend=0},
            }
        })
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, origin)
        assert.is.not_deep_equal(patched, modified)
    end)
    it("changesets without specific pattern should apply to table", function()
        local origin = {
            pools = {
                {accumulate=100,frontend=1300,test=2},
                {accumulate=110,frontend=1200,test=2},
                {accumulate=120,frontend=1100,test=2},
                {accumulate=130,frontend=1000,test=2},
            },
        }
        local modified = Patch:copy(origin)
        for i, pool in pairs(modified.pools) do
            pool.test = pool.test - i
        end
        modified.first = 1

        local patch = Patch:make(origin, modified)
        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("number changed should apply to number", function()
        local origin = 5

        local modified = Patch:copy(origin)
        modified = modified + 6

        local patch = Patch:make(origin, modified)

        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
    it("string changed should apply to string", function()
        local origin = "aaabbb"

        local modified = Patch:copy(origin)
        modified = "cccddd"

        local patch = Patch:make(origin, modified)

        local patched = Patch:apply(origin, patch)

        assert.is.deep_equal(patched, modified)
    end)
end)