{ config, lib, pkgs, osConfig, ... }:

let
  user = osConfig.userSettings;
in
{
  home = {
    username = user.username;
    homeDirectory = user.homeDirectory;
    stateVersion = user.stateVersion;

    # Basic packages that don't need their own feature module
    packages = with pkgs; [
      curl
      unzip
      zip
      ripgrep
    ];
  };  		
  programs.home-manager.enable = true;
}
