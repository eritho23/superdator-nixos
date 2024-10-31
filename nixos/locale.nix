{ pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";

  # TTY localization.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "se-lat6";
  };

  # Set keyboard options for X.
  services.xserver.xkb.layout = "se";

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = ["FiraCode"]; })
  ];
}

