# Nix Config Refactoring Recommendations

## Critical Issues

### 1. Dangerous PAM configuration
**Location**: `darwin/pam.nix:13`

The file itself warns it's "playing with fire" and can break sudo access. This should be properly reviewed and hardened or removed.

**FIXME comment from code**:
```
# FIXME: this implementation is sort of playing with fire. It can break sudo access
```

## Dead/Unused Code

### 2. Commented overlay: overlays/brave.nix
**Location**: `overlays/brave.nix` (45 lines)

File exists but is commented out in `overlays/default.nix:9-11`:
```nix
# (import ./brave.nix {
#   inherit inputs nixpkgs;
# })
```

**Action**: Delete file or document why it's kept for future use.

### 3. Large commented settings block in darwin/base.nix
**Location**: `darwin/base.nix:114-167` (54 lines)

Commented Safari, Mail, AdLib, SoftwareUpdate, TimeMachine, ImageCapture settings.

**Action**: Delete or move to separate `darwin/unused-settings.nix` with explanation.

## Structural Improvements

### 4. services.nix module organization
**Location**: `nixos/services.nix:9`

**Current issues**:
- FIXME noting it's "not the best place"
- Imported in 3/6 NixOS configs (fw, fwd, tp, dev)
- NOT imported in nixos-parallels or wsl
- Contains services that shouldn't run on laptops (eternal-terminal comment)

**Proposed solution**:
Split into separate modules:
```
nixos/
  services/
    tailscale.nix       # common across all
    eternal-terminal.nix  # server-only
    fwupd.nix            # hardware-dependent
```

Or create hardware profiles:
```
nixos/
  profiles/
    server.nix      # imports eternal-terminal
    workstation.nix # imports fwupd, tailscale
    minimal.nix     # minimal services
```

### 5. home-manager/default.nix is monolithic (772 lines)
**Location**: `home-manager/default.nix`

**Current structure**:
- Package definitions (lines 38-43)
- Session variables (lines 45-54)
- Shell aliases (lines 56-171)
- File management (lines 173-194)
- zsh configuration (lines 197-397)
- git, tmux, alacritty, wezterm, zathura, starship configs (lines 399-661)

**Proposed structure**:
```
home-manager/
  shell/
    zsh.nix         # zsh config, completion, keybindings
    aliases.nix     # all aliases
    functions.nix   # run_and_log, hf, tf, etc.
  terminals/
    alacritty.nix
    wezterm.nix
    tmux.nix
  programs/
    git.nix
    starship.nix
    zathura.nix
  default.nix       # imports above, defines home.* settings
  darwin.nix
  nixos-gui.nix
  packages.nix
```

**Benefits**:
- Easier to navigate and maintain
- Logical separation of concerns
- Easier to conditionally enable/disable features

### 6. Naming clarity: nixos-gui vs home-manager/nixos-gui.nix
**Current confusion**:
- `nixos-gui/default.nix` - system-level X11/GNOME config
- `home-manager/nixos-gui.nix` - user-level GUI apps

**Proposed clarification**:
```
nixos/
  gnome.nix (or desktop.nix)  # system-level GUI config

home-manager/
  gui-apps.nix  # user-level GUI applications
```

Or merge system config into conditional in main nixos module.

## TODOs from Codebase

### High Priority TODOs

1. **hardware/parallels.nix:10**
   ```
   # TODO: automate the disk partitioning and look into disko
   ```
   Consider disko for declarative disk management.

2. **home-manager/default.nix:37**
   ```
   # TODO: make lazyvim-nix show up in packages (with an overlay? )
   ```
   Currently using additionalPackages - may be resolved.

3. **darwin/brew.nix:27**
   ```
   # TODO: move to homemanager version of wezeterm once it installs into the apps dir
   ```

4. **home-manager/packages.nix:98**
   ```
   # FIXME: this should be coming from lazyvim-nix
   ```
   (markdownlint-cli)

### Medium Priority TODOs

5. **home-manager/default.nix:10-11**
   ```
   # TODO: this is probably a sign that some parts of these should
   # start getting refactored int separate files.
   ```
   (tmux-tokyo-night plugin) - See issue #9 above.

6. **home-manager/default.nix:57-58**
   ```
   # TODO: this was a raw port of my aliases. These should likely not really
   # just al be dumped into the common alias set. Consider refactoring later.
   ```

7. **home-manager/default.nix:73-74**
   ```
   # TODO: figure out how to do this via the lazyvim config
   nvim = "nvim -";
   ```
   Hack to disable lazyvim startup screen.

8. **home-manager/default.nix:346-348**
   ```
   # TODO: refactor hf and tf into som common updo function.
   # I tried once, but dealing with aray arguments in bash was too much of a
   # a pita.
   ```

9. **home-manager/default.nix:491-493**
   ```
   # TODO: figure out how to use @theme_plugin_datetime_format instead
   ```
   Currently hardcoding tmux status bar override.

10. **home-manager/nixos-gui.nix:39-43**
    ```
    # TODO: this is sort of a hack in that we want verible support on all but darwin
    # since there isn't an arm version of the verible build. Dropping this in the gui
    # file for the moment, as it achieves the short term goal. If this package stays
    # in the nix config, then find it a proper home.. However, it really should be
    # in the lazyvim flake.
    ```

### Low Priority TODOs

11. **home-manager/default.nix:26-28**
    ```
    # FIXME: take this out once possible.
    # See: https://github.com/nix-community/home-manager/issues/4483
    enableNixpkgsReleaseCheck = false;
    ```

## Minor Issues

### 11. Missing fullname in mkDarwinSystem specialArgs
**Location**: `flake.nix` (mkDarwinSystem helper)

The `mkDarwinSystem` helper only passes `user` to specialArgs, not `fullname`. This is inconsistent with `mkNixosSystem` but may be intentional since darwin/base.nix doesn't use it.

**Action**: Document or make consistent.

### 12. Commented lazyvim-nix nixpkgs follows
**Location**: `flake.nix:22`

```nix
lazyvim-nix = {
  url = "github:pbozeman/lazyvim-nix";
  # inputs.nixpkgs.follows = "nixpkgs";
};
```

**Action**: Uncomment or add comment explaining why it's disabled.

### 13. initContent vs initExtra naming
**Location**: `home-manager/default.nix:225`

Uses deprecated `initContent` instead of `initExtra` for zsh.

**Action**: Update to current home-manager API.

## Opportunities for Improvement

### 7. Extract common package sets

**Current state**:
- `nixos/default.nix` defines system packages
- `home-manager/packages.nix` defines user packages
- Some overlap exists

**Proposed structure**:
```
packages/
  common.nix      # shared everywhere (git, vim, curl, etc.)
  dev-tools.nix   # programming languages, tools
  gui.nix         # GUI applications
  darwin.nix      # darwin-specific
```

### 8. Secrets management documentation

**Current state**:
- Simple import from `./secrets`
- SOPS_AGE_KEY_FILE set in home-manager
- sops in packages.nix
- No visible sops-nix integration

**Needs**:
- Document how secrets are encrypted/managed
- Document the secrets structure
- Consider whether sops-nix integration is needed
- Add README in secrets/ directory

### 9. Hardware configurations lack consistency

**Current state**:
- Some use nixos-hardware modules (fw, fwd, tp)
- Others are manual (proxmox, parallels)
- Disk partitioning is manual

**Recommendation**:
Consider disko for declarative disk management across all systems.

## Summary Statistics

- **Total .nix files**: 23
- **Main flake.nix**: ~170 lines (down from 293)
  - **Achieved reduction**: ~120 lines with mkNixosSystem, mkDarwinSystem, mkHomeConfiguration helpers
- **home-manager/default.nix**: 772 lines
  - **Potential reduction**: Split into 5-8 smaller modules
- **TODOs/FIXMEs**: 13+ across codebase
- **Commented dead code**: ~100 lines
- **Remaining potential cleanup**: ~80 lines

## Prioritized Action Plan

### ✅ Completed
1. ~~Fix hardcoded username in `nixos/default.nix:42`~~ - Done
2. ~~Create `mkNixosSystem` helper function~~ - Done
3. ~~Create `mkDarwinSystem` helper function~~ - Done
4. ~~Create `mkHomeConfiguration` helper function~~ - Done

### Phase 1: Critical Fixes (High Impact, Low Risk)
1. Delete or document `overlays/brave.nix`
2. Update `initContent` → `initExtra` in home-manager

### Phase 2: Modularization (Medium Impact, Medium Risk)
3. Split `home-manager/default.nix` into modules
4. Reorganize `nixos/services.nix` structure
5. Clarify nixos-gui naming

### Phase 3: Cleanup (Low Impact, Low Risk)
6. Delete commented Safari settings block
7. Address TODOs in home-manager shell functions
8. Document secrets management approach
9. Add comments to explain design decisions

### Phase 4: Enhancements (Low Priority)
10. Consider disko for disk management
11. Extract common package sets
12. Investigate sops-nix integration

## Implementation Notes

- Test each phase thoroughly before proceeding
- Keep git history clean with logical commits
- Consider creating feature branch for major refactoring
- Ensure all systems can still build after each change:
  ```bash
  nix flake check
  # Test specific configs:
  nix build .#nixosConfigurations.fw.config.system.build.toplevel
  nix build .#darwinConfigurations.mba.system
  ```

## References

- [Nix flake best practices](https://nixos.wiki/wiki/Flakes)
- [Home Manager manual](https://nix-community.github.io/home-manager/)
- [disko - Declarative disk partitioning](https://github.com/nix-community/disko)
