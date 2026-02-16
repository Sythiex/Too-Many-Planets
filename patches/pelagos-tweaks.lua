local util = require("util")

-- coconut processing no longer requires productivity modules to sustain
data.raw.recipe["coconut-processing"].results = {
    {
        type = "item",
        name = "coconut-seed",
        amount = 1,
        probability = 0.1
    }, {
        type = "item",
        name = "coconut-meat",
        amount = 2
    }, {
        type = "item",
        name = "coconut-husk",
        amount = 2
    }
}
