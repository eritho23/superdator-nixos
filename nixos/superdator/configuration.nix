{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./desktop.nix
    # ./hardware-configuration.nix
    ./locale.nix
    ./nix-settings-autoupdate.nix
    ./programs.nix
    ./security.nix
    ./services.nix
    ./users.nix
  ];

  # Set the hostname for rebuilding
  networking.hostName = "superdator";

  # Use UTC as time zone
  time.timeZone = "Etc/UTC";

  boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
