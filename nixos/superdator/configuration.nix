{
  pkgs,
  lib,
  ...
}: {
  imports = [
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

  system.stateVersion = "23.11";
}
