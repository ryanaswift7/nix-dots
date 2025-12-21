
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # nvidia
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

}
