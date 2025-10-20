{ ... }: {
  # Use GRUB for legacy (BIOS) boot
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; # replace with your actual disk (e.g. /dev/nvme0n1)
    configurationLimit = 10;
  };

  # Disable EFI/systemd-boot
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = false;
}
