{ pkgs, lib, ... }:

{
  imports = [
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
    # ./desktop.nix
  ];

  # Set the machine hostname.
  networking.hostName = "superdator";

  # Use UTC as time zone.
  time.timeZone = "Etc/UTC";

  # Boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    grub.enable = lib.mkDefault false;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_6_10;

  # Enable systemd in initrd.
  boot.initrd.systemd.enable = lib.mkDefault true;

  # SOPS secrets.
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets.flinks_password.neededForUsers = true;

    secrets."authelia/jwtSecret".owner            = "authelia-main";
    secrets."authelia/storageEncryptionKey".owner = "authelia-main";
    secrets."authelia/oidcHmacSecret".owner       = "authelia-main";
    secrets."authelia/oidcIssuerPrivateKey".owner = "authelia-main";
    secrets."authelia/sessionSecret".owner        = "authelia-main";
    secrets."authelia/ldapPassword".owner         = "authelia-main";
  };

  system.stateVersion = "23.11";
}

