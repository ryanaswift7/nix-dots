{ config, lib, ... }:
{
  options.systemFeatures.networking.enable  = lib.mkEnableOption "NetworkManager and basic firewall";
  config = lib.mkIf config.systemFeatures.networking.enable {
    networking.networkmanager.enable = true;
    networking.hostName = config.userSettings.hostName;

    networking.firewall = {
      enable = true;
    };

    users.users.${config.userSettings.username}.extraGroups = [ "networkmanager" ];
  };
}
