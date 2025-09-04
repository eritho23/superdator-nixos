{...}: {
  users.groups."remotebuild" = {};

  users.users.remotebuild = {
    isNormalUser = true;
    createHome = false;
    group = "remotebuild";
    extraGroups = ["ssh-access"];

    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFdfSfFNnug6V40jL0MDZzsEVQ+l8IIr3CNsjVXT39q root@SW2311"];
  };

  nix.settings.trusted-users = ["remotebuild"];
}
