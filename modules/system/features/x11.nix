{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.x11;
in
{
  options.systemFeatures.x11 = {
    enable = lib.mkEnableOption "Basic X11 service and utilities";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;

    environment.systemPackages = with pkgs; [
      xclip  # Command line interface to the X11 clipboard
      arandr # Visual tool for managing screen layouts and resolutions
      xrandr
    ];
  };
}
