# Superdator flake

This repo contains the NixOS configuration for a _super_ computer.

## Structure

- The root of the repo has a Nix `flake.nix` with the NixOS configuration
  for the `superdator`.
- In `nixos/`, there should be one directory per hostname (currently one).
- Inside a directory, a `configuration.nix` independent of any flake should
  be present.

## How to use

In order to utilize the flake, you of course need to install `nix`. Then, to
build a test VM with `qemu`, the follwing commands can be used.

```bash
nix build .#nixosConfigurations.<HOSTNAME>.config.system.build.vm

```

## TODO
- Consolidate users and permissions
- Fix Nvidia in Podman
- Upgrade to NixOS 24.05 (when released)
