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

  # Dedicated bridge for the FreeIPA microVM.
  systemd.network.netdevs."br-freeipa" = {
    netdevConfig = {
      Kind = "bridge";
      Name = "br-freeipa";
    };
  };

  systemd.network.networks."10-freeipa-vm" = {
    matchConfig.Name = "vm-freeipa";
    networkConfig = {
      Bridge = "br-freeipa";
    };
    linkConfig.RequiredForOnline = "no";
  };

  systemd.network.networks."10-freeipa-bridge" = {
    matchConfig.Name = "br-freeipa";
    networkConfig = {
      Address = ["10.30.0.1/24"];
      DHCP = "no";
    };
    linkConfig.RequiredForOnline = "no";
  };

  networking.nat = {
    enable = true;
    internalInterfaces = ["br-freeipa"];
    externalInterface = "br0";
    # Forward FreeIPA LDAP and Kerberos ports from the LAN to the FreeIPA VM.
    # HTTPS (443) is handled by Caddy. HTTP (80) is not needed.
    forwardPorts = [
      {destination = "10.30.0.2:389"; proto = "tcp"; sourcePort = 389;}
      {destination = "10.30.0.2:636"; proto = "tcp"; sourcePort = 636;}
      {destination = "10.30.0.2:88"; proto = "tcp"; sourcePort = 88;}
      {destination = "10.30.0.2:464"; proto = "tcp"; sourcePort = 464;}
      {destination = "10.30.0.2:88"; proto = "udp"; sourcePort = 88;}
      {destination = "10.30.0.2:464"; proto = "udp"; sourcePort = 464;}
    ];
  };

  # Allow FreeIPA LDAP/Kerberos ports through the host firewall from the LAN.
  # HTTP/HTTPS are already handled by Caddy.
  networking.firewall.allowedTCPPorts = [88 389 464 636];
  networking.firewall.allowedUDPPorts = [88 464];

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
