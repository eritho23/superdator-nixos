{
  security.sudo = {
    enable = true;
    extraConfig = ''
      Defaults env_reset,pwfeedback
      Defaults lecture = never
    '';
  };

  programs.firejail.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443 5883 8000 11434 25565];
    allowedUDPPorts = [443 25565];
  };

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      # Tailscale
      "100.64.0.0/10"
    ];
  };
}
