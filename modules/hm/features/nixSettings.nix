
{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.nixSettings;
  dots = userSettings.dotfileDirectory;
in
{
  options.homeFeatures.nixSettings.enable = lib.mkEnableOption "Enable flakes and nix experimental features";

  config = lib.mkIf cfg.enable {
    nix = {
      package = pkgs.nix;
      settings.experimental-features = [ "nix-command" "flakes" ];
    };
  };
}
