{pkgs, ...}: {
  # Set options for the tty
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # Set nice tty font and swedish kbd
    font = "Lat2-Terminus16";
    keyMap = "se-lat6";
  };
  # Set keyboard options for X
  services.xserver.xkb.layout = "se";

  # fonts.packages = with pkgs; [];
}
