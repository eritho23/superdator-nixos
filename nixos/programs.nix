{
  pkgs,
  ...
}: let
  pythonWithPip = pkgs.python3.withPackages (po:
    with po; [
      pip
    ]);
in {
  programs = {
    git.enable = true;
    htop.enable = true;
    neovim = {
      defaultEditor = true;
      enable = true;
    };
    tmux.enable = true;
  };

  # # Setup a fancy MOTD
  # programs.rust-motd = {
  #   enable = true;
  #   settings = {
  #     banner = {
  #       color = "green";
  #       command = "${pkgs.figlet}/bin/figlet The Powerhouse";
  #     };
  #     uptime.prefix = "Server uptime: ";
  #     filesystems.root = "/";
  #     memory.swap_pos = "beside";
  #     last_run = {};
  #   };
  # };

  environment.systemPackages = with pkgs; [
    bat
    dust
    fastfetch
    file
    lm_sensors
    nethogs
    nvtopPackages.nvidia
    pciutils
    podman-compose
    pythonWithPip
    ripgrep
    wget
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  programs.nix-ld.enable = true;
}
