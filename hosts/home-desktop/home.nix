{ config, pkgs, inputs, ...}:
let
  user = config.userSettings;
in
{
  home-manager.users."${user.username}" = { ... }: {
    imports = [
          ../../modules/hm
          inputs.dankMaterialShell.homeModules.dankMaterialShell.default
        ];

    homeSuites.workstation = true;
    homeFeatures.school.enable = true;
    home = {
      username = user.username;
      homeDirectory = user.homeDirectory;
      stateVersion = user.homeStateVersion;
    };

    home.packages = with pkgs; [

    ];
    
    programs.home-manager.enable = true;
  };
}
