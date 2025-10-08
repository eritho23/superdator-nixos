{config, ...}: {
  sops.secrets."ros2/users/erre/hashed_password" = {
    neededForUsers = true;
    sopsFile = ../../secrets/ros2.yaml;
  };

  security.doas.enable = true;

  users.mutableUsers = false;

  users.users."erre" = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    hashedPassword = config.sops.secrets."ros2/users/erre/hashed_password".path;
  };
}
