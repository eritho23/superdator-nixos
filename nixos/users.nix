{
  config,
  pkgs,
  ...
}: {
  users.users."erre" = {
    isNormalUser = true;
    uid = 1001;
    initialPassword = "1234";
    extraGroups = ["wheel" "ssh-access" "jupyter-access"];
    packages = with pkgs; [chezmoi];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB5Gyc3DfKNsJ9UrF2xXuvsHe1BkvlltxsfUCYLniiqm abbindgym\\23eritho@SW2311"
    ];
  };

  users.users."malte" = {
    isNormalUser = true;
    uid = 1002;
    initialPassword = "4567";
    extraGroups = ["wheel" "ssh-access" "jupyter-access"];
    # packages = with pkgs; [];
  };

  users.users."nojus" = {
    isNormalUser = true;
    uid = 1003;
    initialPassword = "abcd";
    extraGroups = ["wheel"];
    # packages = with pkgs; [];
  };

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
    hashedPassword = "$y$j9T$aEh.zpaqIc2doGeoIDstX.$bgRWUDMcRn.zX1xRUDFUkgB2NNfFHnS.b8FmtTRuub8";
    extraGroups = ["ssh-access"];
    # packages = with pkgs; [];
  };

  users.users."hannes" = {
    isNormalUser = true;
    uid = 1020;
    hashedPassword = "$y$j9T$I.hNRxV95KMVBVNVibRQW0$kD/YNgHwRMJ18uM1cg7sVPrFqvRwwazKVV4My5pBXP9";
    extraGroups = ["ssh-access"];
  };

  users.users."22erituo" = {
    isNormalUser = true;
    uid = 1021;
    hashedPasswordFile = config.sops.secrets.erituo_password.path;
    extraGroups = ["ssh-access"];
  };

  users.groups."ssh-access" = {};
  users.groups."jupyter-access" = {};
}
