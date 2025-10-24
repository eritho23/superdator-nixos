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
  #isaac = import ./isaac-sim.nix {inherit pkgs;};
in {
  nixpkgs.config.allowUnfree = true;

  # nixpkgs.config.allowUnfreePredicate = pkg:
  # builtins.elem (lib.getName pkg) [
  # "vscode"
  # ];

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
    pciutils
    ripgrep
    tmux
    unzip
    vscode
    wget
    alacritty

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
    #isaac.isaacSimEnv
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
