{ config, pkgs, lib, userSettings, ... }:

let
  cfg = config.systemFeatures.users;
in
{
  options.systemFeatures.users = {
    enable = lib.mkEnableOption "Primary user account configuration";
  };

  config = lib.mkIf cfg.enable {
    users.users.${userSettings.username} = {
      isNormalUser = true;
      description = userSettings.fullName;
      shell = pkgs.zsh;
      
      extraGroups = [ 
        "wheel"
        "networkmanager" 
        "audio" 
        "video" 
        "input"
        "docker"
        "libvirtd"
      ];
    };

    programs.zsh.enable = true;
  };
}
