{
  imports = [
    ./desktop.nix
    ./locale.nix
    ./networking.nix
    ./openssh.nix
    ./programs.nix
    ./users.nix
    ./nix.nix
  ];

  # Change this to include hostname of device?
  users.motd = "Welcome to a ROS 2 minimal dev station!";

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.05";
}
