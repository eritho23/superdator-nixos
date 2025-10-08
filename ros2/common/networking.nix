{
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "10-lan" = {
        matchConfig = {Type = "ether";};
        networkConfig = {DHCP = "yes";};
      };
    };
  };
}
