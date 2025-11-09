# /etc/nixos/home.nix

{ config, pkgs, ... }:

# Import the package lists
let
  package-set = import ./packages.nix { inherit pkgs; };
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

  # --- 2. Use packages in Home Manager options ---
  # This also works perfectly.
  # programs.starship = {
  #   enable = true;
  #   package = pkgs.unstable.starship; # Explicitly using unstable
  # };
  #
  # programs.neovim = {
  #   enable = true;
  #   package = pkgs.unstable.neovim;
  # };
  #
  # programs.git.enable = true;
}
