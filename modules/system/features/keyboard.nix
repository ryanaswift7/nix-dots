{ config, lib, ... }:

let
  cfg = config.systemFeatures.keyboard;
in
{
  options.systemFeatures.keyboard = {
    enable = lib.mkEnableOption "Keyboard layout configuration";
  };

  config = lib.mkIf cfg.enable {
    # Configure keymap in X11 (and Wayland defaults)
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # This ensures the console (TTY) uses the same layout
    console.useXkbConfig = true;
  };
}
