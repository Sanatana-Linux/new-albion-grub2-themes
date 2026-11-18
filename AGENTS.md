# AGENTS.md - New Albion GRUB2 Themes

## Project Overview
This is a GRUB2 theme generation and installation system written in Bash. It creates New Albion themes with various background variants (yerba-buena, fog, 580W, golden-gate) and styles (window, float, sharp, blur).

## Build/Generation Commands
- `./generate.sh` - Generate theme files (use `--help` for options)
- `./install.sh` - Install themes to GRUB (requires sudo, use `--help` for options)
- `./backgrounds/render-backgrounds.sh` - Generate background images from SVG
- `./make-release.sh` - Create release packages

## Code Style Guidelines
- Use bash strict mode: `set -o errexit`
- Variables: UPPERCASE for constants, lowercase for local vars
- Use `readonly` for constants
- Quote all variable expansions: `"${variable}"`
- Use arrays for variants: `THEME_VARIANTS=('yerba-buena' 'fog')`
- Function naming: snake_case
- Error handling: Use `prompt -e` for errors, `prompt -s` for success
- Indentation: 2 spaces
- Use `#!/usr/bin/env bash` shebang

## File Organization
- `core.sh` - Shared functions and constants
- `*.sh` - Executable scripts
- `backgrounds/` - SVG sources and rendered images
- `common/` - Shared assets (fonts, icons)