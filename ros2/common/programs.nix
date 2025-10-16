{
  pkgs,
  # lib,
  ...
}: let
  # Python312 general python env
  python312Packages = ps:
    with ps; [
      # Default python pkgs
    ];
  python312Env = pkgs.python312.withPackages python312Packages;

  # FHS environment for isaac sim
  # NOTE: we use isaac sim 5.0.0 as we have an rtx 50XX
  isaacSimEnv = pkgs.buildFHSEnv {
    name = "isaac-sim-env";
    targetPkgs = pkgs:
      with pkgs; [
        bash
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

        # Standard C++ library
        stdenv.cc.cc.lib

        # Vulkan /lib
        xorg.libXi
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXinerama
        libxkbcommon
        vulkan-loader
        alsa-lib
        pulseaudio
      ];
    profile = ''
      export SHELL=${pkgs.bash}/bin/bash
      export MAMBA_ROOT_PREFIX=/opt/micromamba
      export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH

      # Initialize micromamba env
      export MICROMAMBA_EXE=${pkgs.micromamba}/bin/micromamba
      eval "$($MICROMAMBA_EXE shell hook -s bash)"

      # Welcome msg
      clear
      echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
      echo -e "\e[1;32m Welcome to the Isaac Sim FHS Environment!\e[0m"
      echo -e "\e[1;36m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\e[0m"
      echo -e "Micromamba root: \e[1;33m$MAMBA_ROOT_PREFIX\e[0m"
      echo -e "Python version:  \e[1;33m$(python3 --version 2>/dev/null)\e[0m"
      echo -e "Working dir:     \e[1;33m$(pwd)\e[0m"
      echo
    '';
    runScript = "bash";
  };
in {
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.allowUnfreePredicate = pkg:
  # builtins.elem (lib.getName pkg) [
  # "vscode"
  # ];

  # Safety:
  users.groups.micromamba = {};
  # Create /opt/micromamba with rx for others, rwx for group & root
  systemd.tmpfiles.rules = [
    "d /opt/micromamba 2775 root micromamba -"
  ];

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
