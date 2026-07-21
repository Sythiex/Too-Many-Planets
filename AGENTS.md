# Repository Guidelines

## Project Structure & Module Organization

This repository is a Factorio 2.0/Space Age compatibility and balance mod. `info.json` defines metadata and optional dependencies. Startup toggles live in `settings.lua`, with matching English labels and descriptions in `locale/en/en.cfg`. `data-final-fixes.lua` is the integration entry point and should remain a short list of `require` calls. Put each compatibility change in a focused, kebab-case file under `patches/` (for example, `patches/hovercraft-integration.lua`). Shared prototype mutation helpers belong in `util.lua`. `data.lua` is currently reserved for earlier data-stage work. Record user-visible changes in Factorio's `changelog.txt` format.

## Coding Style & Naming Conventions

Use four-space indentation and trailing commas only where Lua table style already uses them. Prefer `snake_case` for locals and helper functions, `UPPER_SNAKE_CASE` for constants, and kebab-case for patch filenames and setting IDs. Prefix settings with `tmp-`. Guard optional integrations with both `mods["mod-name"]` and their startup setting before accessing foreign prototypes. Keep generic mutations in `util.lua`; keep mod-specific names and balancing values in their patch module. Update locale whenever adding or renaming a setting.

## Testing Guidelines

Leave testing to the user. Do not run Factorio, create test harnesses, or perform automated or manual integration testing unless the user explicitly requests it. When handing off changes, state that testing was not run and briefly identify any relevant in-game checks the user may want to perform.
