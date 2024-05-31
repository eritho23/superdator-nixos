{lib, ...}: {
  services.openssh = {
    allowSFTP = true;
    enable = true;
    openFirewall = lib.mkForce true;
    settings = {
      PasswordAuthentication = true;
      AllowGroups = ["ssh-access"];
      PermitRootLogin = lib.mkForce "no";
    };
  };

  services.cockpit = {
    openFirewall = true;
    enable = true;
  };
}
