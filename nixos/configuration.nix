{
  pkgs,
  lib,
  ...
}: {
  imports = [
    # ./desktop.nix
    # ./deployments.nix
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

  sops.secrets."authelia/jwtSecret".owner = "authelia-main";
  sops.secrets."authelia/storageEncryptionKey".owner = "authelia-main";
  sops.secrets."authelia/oidcHmacSecret".owner = "authelia-main";
  sops.secrets."authelia/oidcIssuerPrivateKey".owner = "authelia-main";
  sops.secrets."authelia/sessionSecret".owner = "authelia-main";
  sops.secrets."authelia/ldapPassword".owner = "authelia-main";

  system.stateVersion = "23.11";
}
