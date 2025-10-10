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
    cmake
    gnumake
    gcc
    clang
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
