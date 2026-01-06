{ config, pkgs, lib, ... }:

{
  options.systemFeatures.intelHardwareAcceleration.enable = lib.mkEnableOption "Intel iGPU hardware acceleration";

  config = lib.mkIf config.systemFeatures.intelHardwareAcceleration.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver  # For Broadwell (2014) or newer processors. LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver  # For older processors. LIBVA_DRIVER_NAME=i965
      ];
    };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "i965"; };
  };
}
