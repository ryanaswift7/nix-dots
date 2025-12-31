{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.browsers;
in
{
  options.systemFeatures.browsers = {
    enable = lib.mkEnableOption "System-wide Firefox and Chromium browsers";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # You can add system-wide policies here later, 
      # like disabling the pocket button or forcing specific extensions.
    };

    programs.chromium = {
      enable = true;
    };

    # Essential for browsers on Wayland (Niri/GNOME)
    # This ensures Chromium/Firefox use the native Wayland backend
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
