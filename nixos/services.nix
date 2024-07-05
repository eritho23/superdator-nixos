{lib, ...}: {
  services.openssh = {
    allowSFTP = true;
    enable = true;
    openFirewall = lib.mkForce true;
    settings = {
      AllowGroups = ["ssh-access"];
      PasswordAuthentication = true;
      PermitRootLogin = lib.mkForce "no";
      X11Forwarding = false;
    };
  };

  services.cockpit = {
    enable = true;
    openFirewall = true;
  };

  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
  nixpkgs.config.cudaSupport = true;
}
