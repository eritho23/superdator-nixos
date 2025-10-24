{
  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-WDC_PC_SN530_SDBPMPZ-256G-1101_214850802788";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "2G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          root = {
            end = "-32G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = ["noatime" "discard"];
              extraArgs = [
                "-L"
                "nixos-root"
                "-m"
                "0"
              ];
            };
          };
          swap = {
            size = "32G";
            content = {
              type = "swap";
              priority = 100;
            };
          };
        };
      };
    };
  };
}
