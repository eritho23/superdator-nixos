{
  imports = [
    ./desktop.nix
    ./locale.nix
    ./networking.nix
    ./openssh.nix
    ./programs.nix
    ./users.nix
  ];

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.05";
}
