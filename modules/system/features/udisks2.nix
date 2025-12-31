{ config, lib, ... }:

let
  cfg = config.systemFeatures.udiskie;
in
{
  options.systemFeatures.udiskie = {
    enable = lib.mkEnableOption "Udisks2 and udiskie for automatic disk mounting";
  };

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;

    environment.systemPackages = with pkgs; [
      udiskie
      gnome-disks 
    ];
  };
}
