{ config, pkgs, lib, ... }:

let
  user = config.userSettings;
  cfg = config.systemFeatures.users;
in
{
  # 1. Declare the "Box" (The Option)
  options.systemFeatures.users = {
    enable = lib.mkEnableOption "Primary user account configuration";
  };

  # 2. Fill the "Box" (The Logic)
  config = lib.mkIf cfg.enable {
    users.users.${user.username} = {
      isNormalUser = true;
      description = user.fullName;
      shell = pkgs.zsh;
      
      extraGroups = [ 
        "wheel"    # Sudo access
        "networkmanager" 
        "audio" 
        "video" 
        "input"
        "docker"   # Added this since you have a Docker suite
        "libvirtd" # Added this for virtualization
      ];
    };

    # Essential for the shell to actually work
    programs.zsh.enable = true;
  };
}
