# Repository Guidelines

## Project Structure & Module Organization

This repository is a Factorio 2.0/Space Age compatibility and balance mod. `info.json` defines metadata and optional dependencies. Startup toggles live in `settings.lua`, with matching English labels and descriptions in `locale/en/en.cfg`. `data-final-fixes.lua` is the integration entry point and should remain a short list of `require` calls. Put each compatibility change in a focused, kebab-case file under `patches/` (for example, `patches/hovercraft-integration.lua`). Shared prototype mutation helpers belong in `util.lua`. `data.lua` is currently reserved for earlier data-stage work. Record user-visible changes in Factorio's `changelog.txt` format.

## Build, Test, and Development Commands

There is no compile step or repository-owned test runner. Develop by linking or copying the checkout into Factorio's mod directory:

```powershell
New-Item -ItemType Junction -Path "$env:APPDATA\Factorio\mods\too-many-planets" -Target (Get-Location)
```

Launch Factorio normally, enable Too Many Planets plus the affected optional mods, and check `factorio-current.log` for data-stage or prototype errors. When a compatible Lua compiler is installed, run a quick syntax pass:

```powershell
Get-ChildItem -Recurse -Filter *.lua | ForEach-Object { luac -p $_.FullName }
```

## Coding Style & Naming Conventions

Use four-space indentation and trailing commas only where Lua table style already uses them. Prefer `snake_case` for locals and helper functions, `UPPER_SNAKE_CASE` for constants, and kebab-case for patch filenames and setting IDs. Prefix settings with `tmp-`. Guard optional integrations with both `mods["mod-name"]` and their startup setting before accessing foreign prototypes. Keep generic mutations in `util.lua`; keep mod-specific names and balancing values in their patch module. Update locale whenever adding or renaming a setting.

## Testing Guidelines

Testing is manual and integration-focused; no coverage target exists. Verify every changed patch with its setting enabled and disabled. Test single-mod guards and all required multi-mod combinations, such as `kry-inserters` plus `lignumis`. Confirm technology prerequisites, recipes, and startup-setting text in-game, and ensure the game loads when optional dependencies are absent.
