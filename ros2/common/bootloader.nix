{
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
  };

  boot.initrd.systemd.enable = true;
}
