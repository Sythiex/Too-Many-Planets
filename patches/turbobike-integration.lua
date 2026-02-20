local util = require("util")

if mods["TurboBike"] and mods["Hovercrafts"] and settings.startup["tmp-turbobike-hoverbike-requires-hovercraft"].value == true then
    -- Hoverbike requires hovercraft
    util.add_tech_prereq("hyper-bike", "hovercraft")
end
