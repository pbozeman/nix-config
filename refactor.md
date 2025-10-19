# Nix Config Refactoring Recommendations

## Critical Issues

### 1. Hardcoded username in nixos/default.nix:42
**Location**: `nixos/default.nix:42`

```nix
# Current (bad):
polkitPolicyOwners = [ "pbozeman" ];

# Should be:
polkitPolicyOwners = [ user ];
```

**Impact**: Breaks reusability if config is used with different username.

### 2. Dangerous PAM configuration
**Location**: `darwin/pam.nix:13`

The file itself warns it's "playing with fire" and can break sudo access. This should be properly reviewed and hardened or removed.

**FIXME comment from code**:
```
# FIXME: this implementation is sort of playing with fire. It can break sudo access
```

## Major Code Duplication

### 3. flake.nix: NixOS system configurations (lines 79-206)

All 6 NixOS configs (fw, fwd, tp, dev, nixos-parallels, wsl) follow nearly identical patterns.

**Current pattern (repeated 6 times)**:
```nix
HOSTNAME =
  let hostname = "HOSTNAME"; in
  nixpkgs.lib.nixosSystem {
    pkgs = mkPkgs "x86_64-linux";
    specialArgs = { inherit inputs nixpkgs secrets hostname user fullname; };
    modules = [
      /* hardware config */
      ./nixos
      /* optional ./nixos/services.nix */
      /* optional ./nixos-gui */
      home-manager.nixosModules.home-manager
      (mkHome user fullname email [ ./home-manager /* optional gui */ ])
    ];
  };
```

**Proposed solution**:
```nix
mkNixosSystem = {
  hostname,
  system ? "x86_64-linux",
  hardwareModules,
  services ? false,
  gui ? false,
  homeModules ? []
}:
  nixpkgs.lib.nixosSystem {
    pkgs = mkPkgs system;
    specialArgs = { inherit inputs nixpkgs secrets hostname user fullname; };
    modules = hardwareModules
      ++ [ ./nixos ]
      ++ lib.optional services ./nixos/services.nix
      ++ lib.optional gui ./nixos-gui
      ++ [
        home-manager.nixosModules.home-manager
        (mkHome user fullname email ([ ./home-manager ] ++ homeModules))
      ];
  };

# Usage:
nixosConfigurations = {
  fw = mkNixosSystem {
    hostname = "fw";
    hardwareModules = [
      hardware.nixosModules.framework-16-7040-amd
      ./hardware/fw.nix
    ];
    services = true;
    gui = true;
    homeModules = [ ./home-manager/nixos-gui.nix ];
  };

  wsl = mkNixosSystem {
    hostname = "wsl";
    hardwareModules = [
      nixos-wsl.nixosModules.wsl
      ./wsl.nix
    ];
  };
};
```

**Estimated reduction**: ~80 lines → ~40 lines

### 4. flake.nix: Darwin system configurations (lines 227-290)

All 4 Darwin configs are 100% identical except for system architecture.

**Current duplication**:
- miles-mba (x86_64-darwin)
- mba (aarch64-darwin)
- mini (aarch64-darwin)
- slabtop (x86_64-darwin)

**Proposed solution**:
```nix
mkDarwinSystem = { system }:
  nix-darwin.lib.darwinSystem {
    inherit system;
    pkgs = mkPkgs system;
    specialArgs = { inherit inputs nixpkgs secrets user; };
    modules = [
      ./darwin
      home-manager.darwinModules.home-manager
      (mkHome user fullname email [
        ./home-manager
        ./home-manager/darwin.nix
      ])
    ];
  };

# Usage:
darwinConfigurations = {
  miles-mba = mkDarwinSystem { system = "x86_64-darwin"; };
  mba = mkDarwinSystem { system = "aarch64-darwin"; };
  mini = mkDarwinSystem { system = "aarch64-darwin"; };
  slabtop = mkDarwinSystem { system = "x86_64-darwin"; };
};
```

**Estimated reduction**: ~60 lines → ~15 lines

### 5. Identical homeConfigurations (lines 209-224)

Both `ubuntu-dev` and `wsl-dev` are 100% identical.

**Options**:
- Combine into single `standalone-home` config
- Remove if unused
- Document why both exist if there's a reason

## Dead/Unused Code

### 6. Commented overlay: overlays/brave.nix
**Location**: `overlays/brave.nix` (45 lines)

File exists but is commented out in `overlays/default.nix:9-11`:
```nix
# (import ./brave.nix {
#   inherit inputs nixpkgs;
# })
```

**Action**: Delete file or document why it's kept for future use.

### 7. Large commented settings block in darwin/base.nix
**Location**: `darwin/base.nix:114-167` (54 lines)

Commented Safari, Mail, AdLib, SoftwareUpdate, TimeMachine, ImageCapture settings.

**Action**: Delete or move to separate `darwin/unused-settings.nix` with explanation.

## Structural Improvements

### 8. services.nix module organization
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

### 9. home-manager/default.nix is monolithic (772 lines)
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

### 10. Naming clarity: nixos-gui vs home-manager/nixos-gui.nix
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

### 11. Missing fullname in darwinConfigurations specialArgs
**Location**: `flake.nix:232` (and other darwin configs)

Darwin configs don't pass `fullname` to specialArgs, only `user`. This is inconsistent with NixOS configs but may be intentional since darwin/base.nix doesn't use it.

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

### 14. Extract common package sets

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

### 15. Secrets management documentation

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

### 16. Hardware configurations lack consistency

**Current state**:
- Some use nixos-hardware modules (fw, fwd, tp)
- Others are manual (proxmox, parallels)
- Disk partitioning is manual

**Recommendation**:
Consider disko for declarative disk management across all systems.

## Summary Statistics

- **Total .nix files**: 23
- **Main flake.nix**: 293 lines
  - **Potential reduction**: ~150 lines with helpers
- **home-manager/default.nix**: 772 lines
  - **Potential reduction**: Split into 5-8 smaller modules
- **TODOs/FIXMEs**: 13+ across codebase
- **Commented dead code**: ~100 lines
- **Total potential cleanup**: 200+ lines

## Prioritized Action Plan

### Phase 1: Critical Fixes (High Impact, Low Risk)
1. Fix hardcoded username in `nixos/default.nix:42`
2. Delete or document `overlays/brave.nix`
3. Update `initContent` → `initExtra` in home-manager
4. Decide on ubuntu-dev/wsl-dev duplication

### Phase 2: Deduplication (High Impact, Medium Risk)
5. Create `mkNixosSystem` helper function
6. Create `mkDarwinSystem` helper function
7. Test all system configurations still build

### Phase 3: Modularization (Medium Impact, Medium Risk)
8. Split `home-manager/default.nix` into modules
9. Reorganize `nixos/services.nix` structure
10. Clarify nixos-gui naming

### Phase 4: Cleanup (Low Impact, Low Risk)
11. Delete commented Safari settings block
12. Address TODOs in home-manager shell functions
13. Document secrets management approach
14. Add comments to explain design decisions

### Phase 5: Enhancements (Low Priority)
15. Consider disko for disk management
16. Extract common package sets
17. Investigate sops-nix integration

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
