{ ... }:

{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk.enable = true;
      };
    };
  };
  services.xserver.displayManager.defaultSession = "xfce";

  # Add sound to the desktop.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}

