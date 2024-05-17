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
        command = "${pkgs.figlet}/bin/figlet Superdator";
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
    file
    pciutils
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  # Enable Nvidia support in containers
  virtualisation.podman.enableNvidia = true;
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia_x11"
    ];
}
