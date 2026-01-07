{ config, pkgs, inputs, userSettings, ...}:
{
  home-manager.users."${userSettings.username}" = { ... }: {
    imports = [
          ../../modules/hm
          inputs.dankMaterialShell.homeModules.dankMaterialShell.default
        ];

    homeSuites.workstation = true;
    homeFeatures.school.enable = true;
    home = {
      username = userSettings.username;
      homeDirectory = userSettings.homeDirectory;
      stateVersion = userSettings.homeStateVersion;
    };

    home.packages = with pkgs; [

    ];
    
    programs.home-manager.enable = true;
  };
}
