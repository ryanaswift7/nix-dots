{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.niri;
  dots = userSettings.dotfileDirectory;
in
{
  options.homeFeatures.niri.enable = lib.mkEnableOption "Niri window manager";

  config = lib.mkIf cfg.enable {

    xdg.configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/niri";
      recursive = true;
    };

    dconf.enable = true;

    programs.mpvpaper.enable = true;
    programs.dankMaterialShell = {
      enable = true;
    };
    xdg.configFile."DankMaterialShell" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/DankMaterialShell";
    };

    home.file.".local/share/wayland-sessions/niri-hm.desktop".text = ''
      [Desktop Entry]
      Name=Niri HM
      Comment=Scrollable-tiling Wayland compositor
      Exec=${pkgs.niri}/bin/niri --session
      Type=Application
    '';
  };
}
