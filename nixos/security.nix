{ ... }:

{
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    extraConfig = ''
      Defaults env_reset,pwfeedback
      Defaults lecture = never
    '';
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 8000 11434 25565];
    allowedUDPPorts = [443 25565];
  };

  programs.firejail = {
    enable = true;
    # TODO: Enforce Firejail profiles by default.
    wrappedBinaries = {};
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      # Tailscale.
      "100.64.0.0/10"
    ];
  };
}

