{
  pkgs,
  lib,
  ...
}: {
  # boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-systemd-boot.enable = lib.mkForce false;
  boot.loader.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = with pkgs; [sbctl];

  boot.initrd.systemd.enable = true;
}
