# Nix Configuration Repository Guide

## Build Commands
- `./bin/darwin-rebuild`: Rebuild macOS configurations
- `./bin/nixos-rebuild`: Rebuild NixOS configurations
- `./bin/home-build`: Rebuild home-manager configurations
- `./bin/gc`: Run garbage collection
- `nix flake update`: Update flake inputs
- `nix flake lock --update-input <input>`: Update specific flake input

## Formatting/Style Guide
- Use 2-space indentation in Nix files
- Follow declarative Nix programming style
- Group related configurations in separate modules
- Use descriptive variable names (e.g., `hostname`, `fullname`)
- Organize by system type (nixos/, darwin/, home-manager/)
- Comment complex configurations
- Use `mkPkgs` function for consistent package definitions
- Keep module imports organized by purpose
- Format lists consistently with one item per line

## Project Structure
- flake.nix: Central configuration defining inputs/outputs
- nixos/: NixOS-specific configurations
- darwin/: macOS-specific configurations
- home-manager/: User environment configurations
- hardware/: Machine-specific hardware configurations
- bin/: Utility scripts for common operations

## Git Commit Format
- Use format: `[🤖][component] description` (robot emoji in brackets at front)
- Do NOT include author attribution (no "Co-Authored-By" or "Generated with Claude Code")
- Example: `[🤖][nixos] use user variable instead of hardcoded username`