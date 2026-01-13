{ config, pkgs, lib, ... }:

{
  systemSuites.workstation = true;
  systemFeatures.nvidia.enable = true;
  systemFeatures.intelHardwareAcceleration.enable = true;

  environment.systemPackages = with pkgs; [

  ];

  specialisation."LTS".configuration = {
    system.nixos.tags = [ "LTS" ];
    environment.etc."specialisation".text =  "LTS";
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  specialisation."GAMING".configuration = {
    system.nixos.tags = [ "GAMING" ];
    environment.etc."specialisation".text =  "GAMING";
    systemSuites.gaming = lib.mkForce true;
  };
}
