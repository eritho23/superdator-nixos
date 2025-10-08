# Superdator flake

This repo contains the NixOS configuration for a _super_ computer.

## For Gustav and Jonathan

### Deploy Kruger

```
ssh root@10.22.3.214 'nixos-rebuild boot --option tarball-ttl 0 --flake github:eritho23/superdator-nixos && reboot'
```

### Deploy Dunning

```
ssh root@10.22.4.33 'nixos-rebuild boot --option tarball-ttl 0 --flake github:eritho23/superdator-nixos && reboot'
```

## Structure

- The root of the repo has a Nix `flake.nix` with the NixOS configuration
  for the `superdator`.
- In `nixos/`, the NixOS configuration is available.
- Inside a directory, a `configuration.nix` independent of any flake should
  be present.

## Usage

In order to utilize the flake, you of course need to install `nix`. Then, to
build a test VM with `qemu`, the follwing commands can be used.

```bash
nix build .#nixosConfigurations.<HOSTNAME>.config.system.build.vm

```

## TODO
- Incorporate changes from @NilsNachname
- Fix `jupyterhub` (watch [Nixpkgs PR #351627](https://github.com/NixOS/nixpkgs/pull/351627))
- Rotate secrets
- Reverse proxy

