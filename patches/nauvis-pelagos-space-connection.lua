local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

-- Add space connection between Nauvis and Pelagos
data:extend({
    {
        type = "space-connection",
        name = "nauvis-pelagos",
        subgroup = "planet-connections",
        from = "nauvis",
        to = "pelagos",
        order = "b[nauvis-pelagos]",
        length = 15000,
        asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_gleba)
    }
})
