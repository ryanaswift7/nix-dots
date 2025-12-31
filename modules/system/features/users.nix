{ config, pkgs, ... }:

let
  user = config.userSettings;
in
{
  # This sets up the user account based on your central settings
  users.users.${user.username} = {
    isNormalUser = true;
    description = user.fullName; # Pulls the "Full Name" from settings
    shell = pkgs.zsh;            # Sets Zsh as the default shell
    
    # Comprehensive default groups
    extraGroups = [ 
      "wheel"
      "audio"
      "video"
      "input"
    ];
  };

  programs.zsh.enable = true;
