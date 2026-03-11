{
  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults env_reset,pwfeedback
      Defaults lecture = never
    '';
  };

  programs.firejail.enable = true;

  # Port spec:
  # - 22: SSH
  # - 80: HTTP (spetsen.net)
  # - 443: HTTPS (spetsen.net)

  # - 30000: Gustav Random Stuff Port
  # - 30001: Elliot Random Stuff Port


  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 5883 8000 11434 30000 30001];
    allowedUDPPorts = [443 30000 30001];
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      # Tailscale
      "100.64.0.0/10"
    ];
  };
}
