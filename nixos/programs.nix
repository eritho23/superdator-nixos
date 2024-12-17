{
  pkgs,
  lib,
  ...
}: {
  programs = {
    fzf.fuzzyCompletion = true;
    git.enable = true;
    htop.enable = true;
    neovim = {
      defaultEditor = true;
      enable = true;
    };
    starship.enable = true;
    tmux.enable = true;
  };

  # Setup a fancy MOTD
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "green";
        command = "${pkgs.figlet}/bin/figlet The Powerhouse";
      };
      uptime.prefix = "Server uptime: ";
      filesystems.root = "/";
      memory.swap_pos = "beside";
      last_run = {};
    };
  };

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
    ripgrep
    wget
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # Enable Nvidia support in containers
  # services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
  hardware.nvidia.datacenter.enable = lib.mkForce true;
  hardware.nvidia-container-toolkit.enable = true;

  programs.nix-ld.enable = true;
}
