{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.udisks2;
in
{
  options.systemFeatures.udisks2 = {
    enable = lib.mkEnableOption "Udisks2 and udiskie for automatic disk mounting";
  };

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
      udiskie
      gnome-disk-utility
    ];
  };
}
