{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/disk/by-id/..."; # FIXME
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
            encryptedSwap = {
              size = "100%";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100;
              };
            };
            root = {
              end = "-32G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                ];
              };
            };
          };
        };
      };
    };
  };
}
