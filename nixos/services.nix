{
  pkgs,
  lib,
  ...
}: let
  ipywebrtc = pkgs.unstable.python312Packages.buildPythonPackage rec {
    pname = "ipywebrtc";
    version = "0.6.0";
    format = "setuptools";

    buildInputs = [pkgs.unstable.python312Packages.jupyter-packaging];

    pythonImportsCheck = [];

    src = pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-+Kw8wCs2M7WfOIrvZ5Yc/1f5ACj9MDuziGxjw9Yx2hM=";
    };
  };
in {
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

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
    acceleration = "cuda";
  };

  /*
    services.open-webui = {
    enable = true;
    port = 9999;
    host = "127.0.0.1";
    environment = {
      ENV = "prod";
      WEBUI_NAME = "Spetsens LLM-chatt";
      WEBUI_AUTH = "False"; # TODO: change to something more secure, e.g. OIDC w/ authelia
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  */

  # TODO: fix jupyterhub

  services.jupyterhub = {
    enable = true;
    authentication = "jupyterhub.auth.PAMAuthenticator";
    extraConfig = ''
      c.Authenticator.allowed_groups = set(["jupyter-access"])
    '';
    kernels = {
      torch = let
        env = pkgs.python3.withPackages (pythonPackages:
          with pythonPackages; [
            pip

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
            torch # PyTorch
            torchaudio
            torchvision
            onnxruntime
            opencv4
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
      malte = let
        env = pkgs.unstable.python312.withPackages (pythonPackages:
          with pythonPackages; [
            scikit-learn

            pip

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
            torch # PyTorch
            torchaudio
            torchvision

            ipywebrtc # CUSTOM
            ipywidgets
            opencv4

            ultralytics
          ]);
      in {
        displayName = "MaltKernel";
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
