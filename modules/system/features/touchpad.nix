{ config, lib, ... }:

let
  cfg = config.systemFeatures.touchpad;
in
{
  options.systemFeatures.touchpad = {
    enable = lib.mkEnableOption "Libinput touchpad support";
  };

  config = lib.mkIf cfg.enable {
    services.libinput = {
      enable = true;

      # Specific touchpad settings
      touchpad = {
        tapping = true;           # Allow clicking by tapping the surface
        naturalScrolling = true;  # "Australian" scrolling (content follows fingers)
        middleEmulation = true;   # Click left+right simultaneously for middle click
        disableWhileTyping = true; # Prevents accidental cursor jumps
      };
    };
  };
}
