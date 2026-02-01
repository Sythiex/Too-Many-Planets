local util = require("util")

-- ------------------------------ Fix Steam Long Hand Inserter broken recipe ------------------------------

util.set_recipe("steam-long-handed-inserter", 0.5, {
    {
        type = "item",
        name = "burner-long-inserter",
        amount = 1
    }, {
        type = "item",
        name = "gold-pipe",
        amount = 2
    }
})

util.set_recipe("steam-long-handed-inserter-iron", 0.5, {
    {
        type = "item",
        name = "burner-long-inserter",
        amount = 1
    }, {
        type = "item",
        name = "pipe",
        amount = 2
    }
})
