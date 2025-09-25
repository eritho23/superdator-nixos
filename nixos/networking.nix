{
  pkgs,
  lib,
  ...
}: {
  networking.firewall = {
    # Tailscale users can bypass the firewall.
    trustedInterfaces = ["tailscale0"];
    # Reverse path filtering drops packets which claim to originate from
    # different subnets than those which they are physically entering through.
    # If set to loose, a similar solution should be implemented manually.
    checkReversePath = "loose";
    # Respond to IPv4 ICMPv4 echo requests. IPv6 responds regardless of this
    # setting.
    # https://mynixos.com/nixpkgs/option/networking.firewall.allowPing
    allowPing = true;
  };

  services.tailscale = {
    enable = true;
    # Open firewall for the tunnel port.
    openFirewall = true;
    port = 41641;
    package = pkgs.unstable.tailscale;
  };

  # Use systemd-resolved for name resolution.
  services.resolved = {
    enable = true;
  };

  networking.useNetworkd = lib.mkDefault true;
  systemd.network.enable = lib.mkDefault true;

  # SpetsCTF services networking.
  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Kind = "bridge";
      Name = "br0";
    };
  };

  systemd.network.networks."11-lan" = {
    matchConfig.Name = ["eno1" "vm-*"];
    networkConfig = {
      Bridge = "br0";
    };
    linkConfig.RequiredForOnline = "no";
  };

  systemd.network.networks."11-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = ["10.22.1.100/16"];
      Gateway = "10.22.1.1";
      DNS = ["10.21.1.2" "10.21.1.3"];
    };
    linkConfig.RequiredForOnline = "routable";
  };
}
