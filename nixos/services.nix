{ pkgs, lib, ... }:

{
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
    host = "0.0.0.0";
    port = 11434;
    acceleration = "cuda";
  };

  services.jupyterhub = {
    enable = true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    kernels = {
      torch = let
        env = pkgs.python311.withPackages (pythonPackages:
          with pythonPackages; [
            # Base for the kernel
            ipykernel

            # Useful utilities
            beautifulsoup4 # Web scraping
            matplotlib # Graphs
            numpy # Of course
            pandas # CSV files
            pillow # Images
            requests # Make API requests
            scipy # Superset of numpy
            torch-bin # PyTorch
            torchaudio-bin
            torchvision-bin
          ]);
      in {
        displayName = "Machine learning kernel (PyTorch)";
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
}

