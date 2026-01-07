{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.systemFeatures;
in {
  options.systemFeatures.bluetooth.enable = mkEnableOption {
      type = types.bool;
      default = false;
      description = "Enable bluetooth but keep it powered off by default at boot.";
  };

  config = mkIf cfg.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          AutoEnable = false;
        };
      };
    };
  };
}
