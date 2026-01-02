{ config, lib, pkgs, ... }:
let
  myFonts = with pkgs.nerd-fonts; [
    jetbrains-mono
    fira-code
    martian-mono
    meslo-lg
    fira-mono
    space-mono
    symbols-only
  ];
in
{
  options.homeFeatures.fonts.enable = lib.mkEnableOption "Selection of fonts";

  config = lib.mkIf config.homeFeatures.fonts.enable {
    home.packages = myFonts;
    fonts.fontconfig.enable = true;
  };
}
