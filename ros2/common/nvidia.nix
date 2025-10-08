{lib, ...}: {
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    open = true;
  };

  nixpkgs.config.cudaSupport = lib.mkDefault true;
}
