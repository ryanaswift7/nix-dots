{ config, pkgs, lib, ... }:

{
  options.systemFeatures.intelHardwareAcceleration.enable = lib.mkEnableOption "Intel iGPU hardware acceleration";

  config = lib.mkIf config.systemFeatures.intelHardwareAcceleration.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  };
}
