{pkgs, ...}: {
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };

  environment.systemPackages = with pkgs; [sbctl];

  boot.initrd.systemd.enable = true;
}
