{
  imports = [
    ./desktop.nix
    ./locale.nix
    ./networking.nix
    ./nvidia.nix
    ./openssh.nix
    ./programs.nix
    ./users.nix
    ./unitree.nix
    ./nix.nix
  ];

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.05";
}
