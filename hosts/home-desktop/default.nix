{ config, pkgs, lib, ... }:

let
  user = {
    username = "ryan";
    fullName = "Ryan Swift";
    email = "ryanaswift7@gmail.com";
    hostName = "home-desktop";
    systemStateVersion = "25.05";
    homeStateVersion = "25.05";
  };
in
{
  imports = [ ./hardware-configuration.nix ];

  userSettings = user;

  systemSuites.workstation = true;
  systemFeatures.nvidia.enable = true;

  home-manager.users."${user.username}" = {
    homeSuites.workstation = true;
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
