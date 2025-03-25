{
  config,
  pkgs,
  ...
}: {
  users.users."erre" = {
    isNormalUser = true;
    uid = 1001;
    initialPassword = "1234";
    extraGroups = ["wheel" "ssh-access"];
    packages = with pkgs; [chezmoi];
    openssh.authorizedKeys.keys = [];
  };

  users.users."malte" = {
    isNormalUser = true;
    uid = 1002;
    initialPassword = "4567";
    extraGroups = ["wheel" "ssh-access"];
    # packages = with pkgs; [];
  };

  users.users."nojus" = {
    isNormalUser = true;
    uid = 1003;
    initialPassword = "abcd";
    extraGroups = ["wheel" "ssh-access"];
    # packages = with pkgs; [];
  };

  users.users."flink" = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets.flinks_password.path;
    uid = 1006;
    extraGroups = ["ssh-access"];
  };

  users.users."nils" = {
    isNormalUser = true;
    uid = 1007;
    initialPassword = "nixos";
    extraGroups = ["wheel" "ssh-access"];
    # packages = with pkgs; [];
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

  users.users."adrian" = {
    isNormalUser = true;
    uid = 1010;
    hashedPassword = "$y$j9T$6Z0OBcsaq6EIk9GRK.ulD1$HyVfbqJlbRsStyNWEgteDkdhjQRtgs8yqCCCy.eu6HB";
    extraGroups = ["ssh-access"];
  };

  users.groups."ssh-access" = {};
}
