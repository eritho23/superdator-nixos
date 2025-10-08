{
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "10-lan" = {
        matchConfig = {Type = "ether";};
        networkConfig = {DHCP = "yes";};
      };
      "11-wifi" = {
        matchConfig = {Name = "wl*";};
        networkConfig = {DHCP = "yes";};
      };
    };
  };

  networking.wireless.iwd.enable = true;
  networking.wireless.iwd.settings = {
    Settings = {
      AutoConnect = true;
    };
  };
}
