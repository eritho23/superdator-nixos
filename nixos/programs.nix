{pkgs, lib, ...}: {
  programs = {
    fzf.fuzzyCompletion = true;
    git.enable = true;
    htop.enable = true;
    neovim = {
      defaultEditor = true;
      enable = true;
    };
    starship.enable = true;
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
    fastfetch
    file
    lm_sensors
    nethogs
    pciutils
    podman-compose
    ripgrep
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # Enable Nvidia support in containers
  hardware.nvidia-container-toolkit.enable = true;
}
