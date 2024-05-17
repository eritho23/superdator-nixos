{
  security.sudo.enable = true;
  security.sudo.extraConfig = ''
    Defaults env_reset,pwfeedback
  '';

  networking.firewall.enable = true;
}
