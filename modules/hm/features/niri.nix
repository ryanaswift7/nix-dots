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
      niri
      xwayland-satellite
    ];

    xdg.configFile."niri/config.kdl".source = 
      let
        fileName = if userSettings.isNixOS then "system_config.kdl" else "standalone_config.kdl";
      in
      config.lib.file.mkOutOfStoreSymlink "${dots}/niri/${fileName}";

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
      Exec=${niri-wrapped}
      Type=Application
      DesktopNames=pop:GNOME
      X-GDM-SessionRegisters=true

    '';
  };
}
