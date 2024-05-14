{pkgs, ...}: {
  users.users."erre" = {
    isNormalUser = true;
    uid = 1009;
    initialPassword = "1234";
    extraGroups = ["wheel"];
    packages = with pkgs; [bat fzf ripgrep helix];
  };

  users.users."temp-debian" = {
    isNormalUser = true;
    uid = 1010;
    initialPassword = "debian";
    packages = [
      (pkgs.writeShellScriptBin "debian-container" ''
        ${pkgs.podman}/bin/podman run --rm docker.io/library/debian:12 bash

        exit 0
      '')
    ];
  };
}
