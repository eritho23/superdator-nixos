{
  pkgs,
  # lib,
  ...
}: let
  # Python312 general python env
  python312Packages = ps:
    with ps; [
      conda
      libmambapy
    ];
  python312Env = pkgs.python312.withPackages python312Packages;

  # FHS environment for isaac sim
  # NOTE: we use isaac sim 5.0.0 as we have an rtx 50XX
  isaacSimEnv = pkgs.buildFHSUserEnv {
    name = "isaac-sim-env";
    targetPkgs = pkgs:
      with pkgs; [
        micromamba
        python311

        # Build tools (required for Isaac Lab and unitree_sdk2_python)
        cmake
        gcc
        gnumake

        # Basic utilities
        git
        which
        zlib

        # Libraries for Isaac Sim GUI/rendering
        libGL
        libGLU
        xorg.libX11
        xorg.libXext
        xorg.libXrender

        # For unitree_sdk2_python (cyclonedds dependency)
        pkg-config
        openssl

        # Standard C++ library (fixes GLIBCXX errors mentioned in troubleshooting)
        stdenv.cc.cc.lib
      ];
    profile = ''
      export CONDA_PREFIX=$HOME/.conda
      export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH
    '';
    runScript = "bash";
  };
in {
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.allowUnfreePredicate = pkg:
  # builtins.elem (lib.getName pkg) [
  # "vscode"
  # ];

  environment.systemPackages = with pkgs; [
    bat
    curl
    dust
    fastfetch
    file
    firefox
    gh # GitHub CLI.
    git
    gnupg
    htop
    keepassxc
    lm_sensors
    ncdu
    neovim
    nethogs
    nodejs
    nvtopPackages.nvidia
    pciutils
    ripgrep
    tmux
    unzip
    vscode
    wget

    # Deps for unitree sdk
    cmake
    gnumake
    gcc
    clang
    yaml-cpp
    eigen
    boost
    spdlog
    fmt

    # custom env
    python312Env
    isaacSimEnv
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
