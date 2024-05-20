{pkgs, ...}: 
{
  users.users."erre" = {
    isNormalUser = true;
    uid = 1001;
    initialPassword = "1234";
    extraGroups = ["wheel" "ssh-access"];
    packages = with pkgs; [helix];
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

  users.users."jakobi" = {
    isNormalUser = true;
    uid = 1004;
    initialPassword = "efgh";
    extraGroups = ["wheel"];
    # packages = with pkgs; [];
  };

  users.users."kjell-urban" = {
    isNormalUser = true;
    uid = 1005;
    initialPassword = "racecar";
    extraGroups = ["wheel"];
    # packages = with pkgs; [];
  };

  users.groups."ssh-access" = {};
}
