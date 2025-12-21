# /etc/nixos/home.nix

{ config, pkgs, ... }:

# Import the package lists
let
  package-set = import ./packages.nix { inherit pkgs; };
  homeDir = config.home.homeDirectory;
  dots = "${homeDir}/nix-dots";
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
    source = config.lib.file.mkOutOfStoreSymlink "${dots}/alacritty";
    recursive = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dots}/nvim";
    recursive = true;
  };

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dots}/niri";
    recursive = true;
  };

  home.file.".ssh/config.tmpl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dots}/ssh/config.tmpl";

  };
}
