{
  services.openssh = {
    enable = true;
    settings = {
      AllowGroups = ["ssh-access"];
      PasswordAuthentication = true;
      PermitRootLogin = "yes"; # NOTE: change for safety in the future
    };
  };
}
