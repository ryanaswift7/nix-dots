{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.niri;
  dots = userSettings.dotfileDirectory;
  niri-wrapped = userSettings.wrapGL pkgs pkgs.niri "niri";
in
{
  options.homeFeatures.niri.enable = lib.mkEnableOption "Niri window manager";

  config = lib.mkIf cfg.enable {
  
    home.packages = with pkgs; [
      # niri
      xwayland-satellite
    ];

    xdg.configFile."niri/config.kdl".source = 
      let
        fileName = if userSettings.isNixOS then "system_config.kdl" else "standalone_config.kdl";
      in
      config.lib.file.mkOutOfStoreSymlink "${dots}/niri/${fileName}";

    xdg.configFile."niri/dms" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/niri/dms";
      recursive = true;
    };

    dconf.enable = true;

    programs.mpvpaper.enable = true;

    programs.dank-material-shell = {
      enable = true;
      enableSystemMonitoring = true;
      dgop.package = pkgs.unstable.dgop;

    };
    xdg.configFile."DankMaterialShell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/DankMaterialShell";
    };
  };
}
