{ config, pkgs, lib, ... }:

{
  systemSuites.workstation = true;
  systemFeatures.nvidia.enable = true;
  systemFeatures.intelHardwareAcceleration.enable = true;

  environment.systemPackages = with pkgs; [

  ];

  specialisation."LTS".configuration = {
    system.nixos.tags = [ "LTS" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  specialisation."GAMING".configuration = {
    system.nixos.tags = [ "GAMING" ];
    systemSuites.gaming = lib.mkForce true;
  };
}
