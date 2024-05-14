{pkgs, ...}: {
  programs = {
    htop.enable = true;
    starship.enable = true;
    fzf.fuzzyCompletion = true;
  };

  environment.systemPackages = with pkgs; [
    bat
    ripgrep
  ];

  security.sudo-rs.enable = true;

  virtualisation.podman.enable = true;
}
