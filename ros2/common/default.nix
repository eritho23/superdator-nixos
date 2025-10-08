{
  imports = [
    ./desktop.nix
    ./initial-root-access.nix
    ./networking.nix
    ./openssh.nix
    ./users.nix
  ];

  system.stateVersion = "25.05";
}
