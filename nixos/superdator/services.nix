{
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
}
