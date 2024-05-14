{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./users.nix
    ./services.nix
    ./programs.nix
  ];

  networking.hostName = "superdator";

  system.stateVersion = "24.05";
}
