{
  security.sudo.enable = true;
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
  '';

  networking.firewall.enable = true;

  services.fail2ban = {
    enable = true;
    ignoreIP = [
      # Tailscale
      "100.64.0.0/10"
    ];
  };
}
