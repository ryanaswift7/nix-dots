{ config, lib, pkgs, ... }:

{
  options.systemFeatures.boot.enable = lib.mkEnableOption "Bootloader and Kernel config";

  config = lib.mkIf config.systemFeatures.boot.enable {
    boot.loader.systemd-boot = {
      enable = true;
      configurationLimit = 3;
      memtest86.enable = true;
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.initrd.systemd.enable = true;

    swapDevices = [{
      device = "/var/lib/swapfile";
      size = 32 * 1024; # 32 GB
    }];
  };
}
