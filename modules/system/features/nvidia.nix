{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.nvidia;
in
{
  options.systemFeatures.nvidia = {
    enable = lib.mkEnableOption "Proprietary Nvidia drivers and hardware acceleration";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true; # Required for Steam and many games
    };

    hardware.nvidia = {
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep issues.
      # Usually leave off unless you are on a laptop.
      powerManagement.enable = false;
      powerManagement.finegrained = false;

      # Use the Nvidia open source kernel module (not the same as Nouveau)
      # Support is good for 20-series and newer. Set to false for older cards.
      open = true;

      # Enable the Nvidia settings menu, accessible via `nvidia-settings`
      nvidiaSettings = true;

      # Choose the driver version (stable is usually best)
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
