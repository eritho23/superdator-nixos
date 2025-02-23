{
  config,
  lib,
  ...
}: {
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["nvidia"];

  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # datacenter.enable = true;
    open = true;
  };

  nixpkgs.config.cudaSupport = lib.mkDefault true;
}
