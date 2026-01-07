{ config, lib, pkgs, inputs, userSettings, ... }:

let
  cfg = config.systemFeatures.homeManager;
in
{
  options.systemFeatures.homeManager = {
    enable = lib.mkEnableOption "Home Manager NixOS integration";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      backupFileExtension = "preHM";
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs userSettings; };
    };
  };
}
