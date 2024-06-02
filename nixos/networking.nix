{
  pkgs,
  lib,
  ...
}: {
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    package = pkgs.unstable.tailscale;
  };

  networking.firewall.allowPing = true;

  services.resolved = {
    enable = true;
  };

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
