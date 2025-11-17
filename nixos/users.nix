{
  config,
  pkgs,
  ...
}: {
  users.users."erre" = {
    isNormalUser = true;
    uid = 1001;
    initialPassword = "1234";
    extraGroups = ["wheel" "ssh-access" "jupyter-access" "libvirtd"];
    packages = with pkgs; [chezmoi];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5Gyc3DfKNsJ9UrF2xXuvsHe1BkvlltxsfUCYLniiqm abbindgym\\23eritho@SW2311"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOQ2hC/K2bY78aJVLFJ8Y5foAR/LUivup+Aeqcrf6wfm erre@obsidian"
    ];
  };

  # users.users."malte" = {
  #   isNormalUser = true;
  #   uid = 1002;
  #   initialPassword = "4567";
  #   extraGroups = ["wheel" "ssh-access" "jupyter-access"];
  #   # packages = with pkgs; [];
  # };

  # users.users."nojus" = {
  #   isNormalUser = true;
  #   uid = 1003;
  #   initialPassword = "abcd";
  #   extraGroups = ["wheel"];
  #   # packages = with pkgs; [];
  # };

  users.users."flink" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.flinks_password.path;
    uid = 1006;
    extraGroups = ["ssh-access" "jupyter-access"];
  };

  users.users."nils" = {
    isNormalUser = true;
    uid = 1007;
    initialPassword = "nixos";
    extraGroups = ["wheel" "ssh-access" "jupyter-access"];
    # packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvLI8Eo8iu1wd36nsdRwGaElTCVKF2B/GE0KYXD4sVm nils@atlasaves.com"
    ];
  };

  users.users."ianterzo" = {
    isNormalUser = true;
    uid = 1008;
    initialPassword = "nixos";
    extraGroups = ["ssh-access"];
    # packages = with pkgs; [];
  };

  users.users."beni" = {
    isNormalUser = true;
    uid = 1009;
    hashedPasswordFile = config.sops.secrets."beni_hashed_password".path;
    extraGroups = ["ssh-access"];
    # packages = with pkgs; [];
  };

  users.users."hannes" = {
    isNormalUser = true;
    uid = 1020;
    hashedPasswordFile = config.sops.secrets."hannes_hashed_password".path;
    extraGroups = ["ssh-access"];
  };

  users.users."gustav" = {
    isNormalUser = true;
    uid = 1021;
    hashedPasswordFile = config.sops.secrets."gustav_hashed_password".path;
    extraGroups = ["ssh-access" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVQjtd/jEPI3IgWyKiwvBD9S2hbLEZ249tOy8HpN2Ci gustav.pettersson2@outlook.com"
    ];
  };

  users.groups."ssh-access" = {};
  users.groups."jupyter-access" = {};
}
