{
  pkgs,
  lib,
  outputs,
  ...
}: {
  imports = [
    # ./desktop.nix
    ./deployments.nix
    ./authelia.nix
    ./hardware-configuration.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./programs.nix
    ./reverse-proxy.nix
    ./security.nix
    ./services.nix
    ./users.nix
    ./vm.nix
  ];

  nixpkgs.overlays = [outputs.overlays.unstable-packages];

  # Set the hostname.
  networking.hostName = "superdator";

  # Use UTC as time zone.
  time.timeZone = "Etc/UTC";

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable systemd-based initrd.
  boot.initrd.systemd.enable = lib.mkDefault true;

  # SOPS secrets.
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  sops.secrets.flinks_password.neededForUsers = true;

  sops.secrets."beni_ghcr_token" = {};
  sops.secrets."beni_environ_file" = {};

  # Authelia
  sops.secrets = {
    "authelia/jwtSecret".owner = "authelia-main";
    "authelia/storageEncryptionKey".owner = "authelia-main";
    "authelia/oidcHmacSecret".owner = "authelia-main";
    "authelia/oidcIssuerPrivateKey".owner = "authelia-main";
    "authelia/sessionSecret".owner = "authelia-main";
    "authelia/ldapPassword".owner = "authelia-main";
  };

  system.stateVersion = "23.11";
}
