{ config, pkgs, inputs, userSettings, ...}:
{
    imports = [
          ../../modules/hm
          inputs.dankMaterialShell.homeModules.dankMaterialShell.default
        ];

    homeSuites.workstation = true;
    homeFeatures.school.enable = true;
    homeFeatures.nixSettings.enable = true;
    home = {
      username = userSettings.username;
      homeDirectory = userSettings.homeDirectory;
      stateVersion = userSettings.homeStateVersion;
    };

    home.packages = with pkgs; [
      nixgl.auto.nixGLDefault
      nixgl.nixGLIntel
    ];
    
    programs.home-manager.enable = true;
}
