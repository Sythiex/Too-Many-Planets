local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")

-- Add space connection between Nauvis and Pelagos
if mods["pelagos"] and settings.startup["tmp-pelagos-before-gleba"].value == true then
    data:extend({
        {
            type = "space-connection",
            name = "nauvis-pelagos",
            subgroup = "planet-connections",
            from = "nauvis",
            to = "pelagos",
            order = "b[nauvis-pelagos]",
            length = 25000,
            asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_gleba),
            redrawn_connections_keep = true,
            redrawn_connections_rescale = true
        }
    })
end
