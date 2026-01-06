{ config, pkgs, lib, inputs, ... }:

{
  systemSuites.workstation = true;
  systemFeatures.nvidia.enable = true;
  systemFeatures.intelHardwareAcceleration.enable = true;

  # to directly add a new package
  environment.systemPackages = with pkgs; [

  ];

  home-manager.users."${config.userSettings.username}" = { ... }: {
    homeSuites.workstation = true;
    homeFeatures.school.enable = true;
  };

  specialisation."LTS".configuration = {
    system.nixos.tags = [ "LTS" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  specialisation."GAMING".configuration = {
    system.nixos.tags = [ "GAMING" ];
    systemSuites.gaming = lib.mkForce true;
  };
}
