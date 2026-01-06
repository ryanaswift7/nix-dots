{ config, pkgs, ...}:
{
  home-manager.users."${config.userSettings.username}" = { ... }: {
    homeSuites.workstation = true;
    homeFeatures.school.enable = true;

    home.packages = with pkgs; [

    ];
  };
}
