{lib, ...}: {
  disko.devices.disk.nvme = {
    type = "disk";
    device = "/dev/nvme0n1";

    content = {
      type = "gpt";
      partitions = {
        FIRMWARE = {
          label = "FIRMWARE";
          priority = 1;

          type = "0700"; # Microsoft basic data
          attributes = [
            0 # Required Partition
          ];

          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot/firmware";
            mountOptions = [
              "noatime"
              "noauto"
              "x-systemd.automount"
              "x-systemd.idle-timeout=1min"
            ];
          };
        };

        ESP = {
          label = "ESP";

          type = "EF00"; # EFI System Partition
          attributes = [
            2 # Legacy BIOS bootable (U-Boot / extlinux)
          ];

          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "noatime"
              "noauto"
              "x-systemd.automount"
              "x-systemd.idle-timeout=1min"
              "umask=0077"
            ];
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
          };
        };
      };
    };
  };
}
