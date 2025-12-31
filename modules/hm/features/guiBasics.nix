{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.guiBasics;
in
{
  options.homeFeatures.guiBasics = {
    enable = lib.mkEnableOption "basic GUI applications (Firefox, Kitty, btop, udiskie)";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      btop.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      udiskie.enable = true;
    };

    home.packages = with pkgs; [
      brave
      google-chrome
      celluloid
      vlc
      imv
      cliphist
      wl-clipboard
      xclip
      networkmanager-openconnect
      kdePackages.dolphin
    ];
  };
}
