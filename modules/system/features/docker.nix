{ config, lib, ... }:

let
  cfg = config.systemFeatures.docker;
in
{
  options.systemFeatures.docker = {
    enable = lib.mkEnableOption "Docker container engine";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };

    # Add the primary user to the docker group
    users.users.${config.userSettings.username}.extraGroups = [ "docker" ];
  };
}
