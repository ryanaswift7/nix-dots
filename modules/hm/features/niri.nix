{ config, lib, pkgs, osConfig, ... }:

let
  cfg = config.homeFeatures.niri;
  dots = osConfig.userSettings.dotfileDirectory;
in
{
  options.homeFeatures.niri.enable = lib.mkEnableOption "Niri window manager";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # niri
      # xwayland-satellite
    ];

    xdg.configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/niri";
      recursive = true;
    };

    # Optional: Enable dconf (required for some GTK settings in Niri)
    dconf.enable = true;

    programs.mpvpaper.enable = true;
    programs.dankMaterialShell = {
      enable = true;
      systemd.enable = true;
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
