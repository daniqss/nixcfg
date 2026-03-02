{...}: {
  disko.devices = {
    disk = {
      my-disk = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };

            swap = {
              label = "SWAP";
              size = "16G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };

            root = {
              label = "ROOT";
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                ];
                extraArgs = ["-O" "encrypt"];
              };
            };
          };
        };
      };
    };
  };
}
