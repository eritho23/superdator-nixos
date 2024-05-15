{pkgs, ...}: {
  programs = {
    fzf.fuzzyCompletion = true;
    htop.enable = true;
    starship.enable = true;
    vim.defaultEditor = true;
  };

  # Setup a fancy MOTD
  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "green";
        command = "${pkgs.figlet}/bin/figlet Joakim Flink";
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
    ripgrep
    nethogs
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # Enable Nvidia support in containers
  # virtualisation.containers.cdi.dynamic.nvidia.enable = true;
}
