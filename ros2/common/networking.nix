{pkgs, ...}: {
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

  networking.firewall = {
    # Tailscale should be allowed past firewall
    trustedInterfaces = ["tailscale0"];
  };

  services.tailscale = {
    enable = true;
    package = pkgs.unstable.tailscale;
  };
}
