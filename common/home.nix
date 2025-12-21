# /etc/nixos/home.nix

{ config, pkgs, ... }:

# Import the package lists
let
  package-set = import ./packages.nix { inherit pkgs; };
  homeDir = config.home.homeDirectory;
in
{
  imports = [
    ./hm-programs.nix
  ];	

  # Set user and home directory.
  # These are used by the standalone builder.
  home.username = "ryan";
  home.homeDirectory = "/home/ryan";

  home.stateVersion = "25.05";

  # --- 1. Use the user packages list ---
  home.packages = package-set.ryan;

  xdg.configFile."alacritty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${homeDir}/nix-dots/alacritty";
    recursive = true;
  };
}
