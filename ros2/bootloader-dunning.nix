{
  pkgs,
  lib,
  ...
}: {
  boot.loader.systemd-systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = with pkgs; [sbctl];

  boot.initrd.systemd.enable = true;
}
