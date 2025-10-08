{config, ...}: {
  sops.secrets."ros2/users/erre/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  security.doas.enable = true;

  users.mutableUsers = false;

  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5Gyc3DfKNsJ9UrF2xXuvsHe1BkvlltxsfUCYLniiqm abbindgym\23eritho@SW2311" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVQjtd/jEPI3IgWyKiwvBD9S2hbLEZ249tOy8HpN2Ci gustav.pettersson2@outlook.com"];

  users.users."erre" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.sops.secrets."ros2/users/erre/hashed_password".path;
  };
}
