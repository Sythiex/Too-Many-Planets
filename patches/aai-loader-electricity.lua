local util = require("util")

if mods["aai-loaders"] and settings.startup["tmp-aai-loaders-require-electricity"].value == true then
    local LOADER_POWER = {
        ["aai-loader"] = {
            energy_per_item = "8.133kJ",
            drain = "3kW"
        }, -- ~125kW max consumption
        ["aai-fast-loader"] = {
            energy_per_item = "8.133kJ",
            drain = "6kW"
        }, -- ~250kW max consumption
        ["aai-express-loader"] = {
            energy_per_item = "8.133kJ",
            drain = "9kW"
        }, -- ~375kW max consumption
        ["aai-turbo-loader"] = {
            energy_per_item = "8.133kJ",
            drain = "12kW"
        }, -- ~500kW max consumption
        ["aai-hyper-loader"] = {
            energy_per_item = "8.133kJ",
            drain = "15kW"
        } -- ~625kW max consumption
    }

    local function make_electric(loader, cfg)
        if not loader or not cfg then
            return false
        end

        loader.energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            drain = cfg.drain
        }

        loader.energy_per_item = cfg.energy_per_item
        return true
    end

    for name, cfg in pairs(LOADER_POWER) do
        local proto = (data.raw["loader-1x1"] and data.raw["loader-1x1"][name]) or (data.raw["loader"] and data.raw["loader"][name])

        if proto then
            make_electric(proto, cfg)
        else
            log(("Too Many Planets: loader not found (skipped): %s"):format(name))
        end
    end
end
