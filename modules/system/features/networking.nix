{ config, lib, pkgs, userSettings, ... }:
{
  options.systemFeatures.networking.enable  = lib.mkEnableOption "NetworkManager and basic firewall";
  config = lib.mkIf config.systemFeatures.networking.enable {
    networking.networkmanager.enable = true;
    networking.hostName = userSettings.hostName;

    networking.firewall = {
      enable = true;
    };

    users.users.${userSettings.username}.extraGroups = [ "networkmanager" ];

    environment.systemPackages = with pkgs; [
      openconnect-sso
    ];
  };
}
