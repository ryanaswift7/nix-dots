{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.distrobox;
in
{
  options.systemFeatures.distrobox = {
    enable = lib.mkEnableOption "Distrobox for mutable environments";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      distrobox
      xorg.xhost # Required to allow GUI apps in Distrobox to reach your screen
    ];
  };
}
