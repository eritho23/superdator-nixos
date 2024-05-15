{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager = {
      defaultSession = "xfce";
      lightdm = {
        enable = true;
        greeters.gtk.enable = true;
      };
    };
  };
}
