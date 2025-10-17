{
  services.openssh = {
    enable = true;
    settings = {
      AllowGroups = ["ssh-access"];
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
