{pkgs, lib, ...}: {
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

  # Enable systemd-networkd.
  networking.useNetworkd = lib.mkDefault true;
  systemd.network.enable = lib.mkDefault true;

  systemd.network.networks."10-lan" = {
    matchConfig.Name = "eno1";
    matchConfig.MACAddress = "10:7c:61:0b:8b:68";

    address = ["10.22.1.100/16"];
    gateway = ["10.22.1.1"];
    dns = ["10.21.1.2" "10.21.1.3"];
  };
}
