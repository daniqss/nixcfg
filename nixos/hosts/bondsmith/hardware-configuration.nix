{config, ...}: {
  boot.loader.raspberry-pi = {
	enable = true;
  	bootloader = "kernel";
  };

  system.nixos.tags = let
    cfg = config.boot.loader.raspberry-pi;
  in [
    "raspberry-pi-${cfg.variant}"
    cfg.bootloader
    config.boot.kernelPackages.kernel.version
  ];

  hardware.raspberry-pi.config = {
    # [all] conditional filter, https://www.raspberrypi.com/documentation/computers/config_txt.html#conditional-filters
    all.options = {
      # https://www.raspberrypi.com/documentation/computers/config_txt.html#enable_uart
      # in conjunction with `console=serial0,115200` in kernel command line (`cmdline.txt`)
      # creates a serial console, accessible using GPIOs 14 and 15 (pins
      #  8 and 10 on the 40-pin header)
      enable_uart = {
        enable = true;
        value = true;
      };

      # https://www.raspberrypi.com/documentation/computers/config_txt.html#uart_2ndstage
      # enable debug logging to the UART, also automatically enables
      # UART logging in `start.elf`
      uart_2ndstage = {
        enable = true;
        value = true;
      };
    };
  };
}
