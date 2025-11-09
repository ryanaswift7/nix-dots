# /etc/nixos/programs.nix
#
# This is a Nix module that holds all your *enabled*
# user programs, which will be shared everywhere.
{ config, pkgs, ... }:

{
  # --- All your shared, enabled programs go here ---
  
  programs.git = {
    enable = true;
    userName = "Your Name";
    userEmail = "your@email.com";
  };

  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
    enableZshIntegration = true;
  };

  programs.zellij = {
    enable = true;
    package = pkgs.unstable.zellij;
  };

  programs.neovim = {
    enable = true;
    package = pkgs.unstable.neovim;
    # ... your nvim config
  };

  programs.firefox.enable = true;

  programs.zsh.enable = true;
}
