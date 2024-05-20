{pkgs, ...}: {
  services.openssh = {
    allowSFTP = true;
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = true;
      AllowGroups = ["ssh-access"];
    };
  };

  services.cockpit = {
    openFirewall = true;
    enable = true;
  };

  services.tailscale = {
    enable = true;
    openFirewall = true;
    package = pkgs.unstable.tailscale;
  };
}
