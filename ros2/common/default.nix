{
  imports = [
    ./bootloader.nix
    ./desktop.nix
    ./initial-root-access.nix
    ./locale.nix
    ./networking.nix
    ./openssh.nix
    ./programs.nix
    ./users.nix
  ];

  system.stateVersion = "25.05";
}
