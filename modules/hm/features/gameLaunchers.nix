{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.gameLaunchers;
in
{
  options.homeFeatures.gameLaunchers = {
    enable = lib.mkEnableOption "Lutris and Heroic launchers";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lutris
      heroic
      bottles # Great for managing custom Wine prefixes
      protontricks # Essential for fixing Steam games
      protonup-qt
    ];
  };
}
