{ config, lib, pkgs, userSettings, ... }:
{
  options.systemFeatures.networking.enable  = lib.mkEnableOption "NetworkManager and basic firewall";
  config = lib.mkIf config.systemFeatures.networking.enable {
    networking.networkmanager = {
      enable = true;
      plugins = [
        pkgs.networkmanager-openconnect
      ];
      ensureProfiles.profiles.usc = {
        connection = {
          id = "usc";
          type = "vpn";
        };

        vpn = {
          service-type = "org.freedesktop.NetworkManager.openconnect";
          gateway = "vpn.usc.edu";
          protocol = "anyconnect";
          useragent = "AnyConnect";
        };
      };
    };
    networking.hostName = userSettings.hostName;

    networking.firewall = {
      enable = true;
    };

    users.users.${userSettings.username}.extraGroups = [ "networkmanager" ];

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];

    programs.nm-applet.enable = true;

  };
}
