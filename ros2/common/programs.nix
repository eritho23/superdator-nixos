{
  pkgs,
  # lib,
  ...
}: {
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
    python3
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

    # conda 
    python312Packages.conda 
    python312Packages.libmambapy
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
