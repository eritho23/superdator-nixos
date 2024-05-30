{pkgs, ...}: {
  networking.firewall = {
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };

  networking.useNetworkd = true;

  services.tailscale = {
    enable = true;
    openFirewall = true;
    package = pkgs.unstable.tailscale;
  };

  services.resolved = {
    enable = true;
  };
}
