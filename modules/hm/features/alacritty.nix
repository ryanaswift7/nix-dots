{ config, lib, pkgs, osConfig, ... }:

let
  cfg = config.homeFeatures.alacritty;
  dots = osConfig.userSettings.dotfileDirectory;
in
{
  options.homeFeatures.alacritty.enable = lib.mkEnableOption "Alacritty terminal with custom dotfiles";

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;

    xdg.configFile."alacritty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/alacritty";
      recursive = true;
    };

  };
}
