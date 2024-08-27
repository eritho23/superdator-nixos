{
  security.sudo.enable = true;
  security.sudo.execWheelOnly = true;
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
    Defaults lecture = never
  '';

  networking.firewall.enable = true;

  programs.firejail.enable = true;

  networking.firewall.allowedTCPPorts = [22 80 443 8000 25565];
  networking.firewall.allowedUDPPorts = [443 25565];

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      # Tailscale
      "100.64.0.0/10"
    ];
  };
}
