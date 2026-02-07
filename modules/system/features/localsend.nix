{ config, lib, pkgs, userSettings, ... }:
{
  options.systemFeatures.localsend.enable  = lib.mkEnableOption "Localsend (install and port opening)";
  config = lib.mkIf config.systemFeatures.localsend.enable {

    programs.localsend.enable = true;

    # networking.firewall.allowedTCPPorts = [ 53317 ];
    # networking.firewall.allowedUDPPorts = [ 53317 ];
    # environment.systemPackages = with pkgs; [
    #   localsend
    # ];
  };
}
