{
  services.openssh = {
    enable = true;
    settings = {
      AllowGroups = "ssh-access";
      PasswordAuthentication = true;
      PermitRootLogin = "no"; # NOTE: change for safety in the future
    };
  };
}

