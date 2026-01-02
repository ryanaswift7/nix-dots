{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.systemFeatures.homeManager;
  user = config.userSettings;
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
      extraSpecialArgs = { inherit inputs user; };

      users."${user.username}" = { ... }: {
        imports = [
          ../../hm
          inputs.dankMaterialShell.homeModules.dankMaterialShell.default
        ];

        home = {
          username = user.username;
          homeDirectory = user.homeDirectory;
          stateVersion = user.homeStateVersion;

        };

        programs.home-manager.enable = true;
      };
    };
  };
}
