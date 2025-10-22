{config, ...}: {
  sops.secrets."ros2/users/erre/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/gustav/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/jonathan/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/ahmad/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/marcus/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/salma/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/lucas/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/ludvig/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/aidin/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/raina/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  sops.secrets."ros2/users/strom/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  users.groups = {
    micromamba = {};
    ssh-access = {};
  };

  security.doas.enable = true;

  users.mutableUsers = false;

  users.users."root".openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5Gyc3DfKNsJ9UrF2xXuvsHe1BkvlltxsfUCYLniiqm abbindgym\23eritho@SW2311" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVQjtd/jEPI3IgWyKiwvBD9S2hbLEZ249tOy8HpN2Ci gustav.pettersson2@outlook.com"];

  users.users."erre" = {
    description = "Eric (230S)";
    isNormalUser = true;
    extraGroups = ["ssh-access" "wheel"];
    hashedPasswordFile = config.sops.secrets."ros2/users/erre/hashed_password".path;
  };

  users.users."gustav" = {
    description = "Gustav (240S)";
    isNormalUser = true;
    extraGroups = ["ssh-access" "wheel" "micromamba"];
    hashedPasswordFile = config.sops.secrets."ros2/users/gustav/hashed_password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVQjtd/jEPI3IgWyKiwvBD9S2hbLEZ249tOy8HpN2Ci gustav.pettersson2@outlook.com"
    ];
  };

  users.users."jonathan" = {
    description = "Jonathan (240S)";
    isNormalUser = true;
    extraGroups = ["ssh-access" "wheel"];
    hashedPasswordFile = config.sops.secrets."ros2/users/jonathan/hashed_password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPbqVTascQiJYBzBLwvQhI8z/4bQh4NV9wNGkRicGnTd jonathan@wahrenberg.com"
    ];
  };

  users.users."ahmad" = {
    description = "Ahmad";
    isNormalUser = true;
    extraGroups = ["ssh-access" "wheel"];
    hashedPasswordFile = config.sops.secrets."ros2/users/ahmad/hashed_password".path;
  };

  users.users."marcus" = {
    description = "Marcus (230S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/marcus/hashed_password".path;
  };

  users.users."salma" = {
    description = "Salma (240S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/salma/hashed_password".path;
  };

  users.users."lucas" = {
    description = "Lucas (240S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/lucas/hashed_password".path;
  };

  users.users."ludvig" = {
    description = "Ludvig (240S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/ludvig/hashed_password".path;
  };

  users.users."aidin" = {
    description = "Aidin (240S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/aidin/hashed_password".path;
  };

  users.users."raina" = {
    description = "Raina (240S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/raina/hashed_password".path;
  };

  users.users."strom" = {
    description = "Gustav Strom (230S)";
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."ros2/users/strom/hashed_password".path;
  };
}
