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

  # Change this to include hostname of device?
  users.motd = "Welcome to a ROS 2 dev station!"

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = "25.05";
}
