{
  pkgs,
  lib,
  ...
}: {
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

  services.jupyterhub = {
    enable = true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    kernels = {
      torch = let
        env = pkgs.python3.withPackages (pythonPackages:
          with pythonPackages; [
            ipykernel
            numpy
            pandas
            torch-bin
            torchaudio-bin
            torchvision-bin
          ]);
      in {
        displayName = "Machine learning with PyTorch";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
        logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
      };
    };
  };

  nixpkgs.config.cudaSupport = true;
}
