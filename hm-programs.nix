# This is a Nix module that holds all your *enabled*
# user programs, which will be shared everywhere.
{ config, pkgs, ... }:

{
  # --- All your shared, enabled programs go here ---
  
  programs.git = {
    enable = true;
    userName = "Ryan Swift";
    userEmail = "ryanaswift7@gmail.com";
  };

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableZshIntegration = true;
  };


  programs.neovim = {
    enable = true;
    # package = pkgs.unstable.neovim;
    # ... your nvim config
  };

  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.fish = {
    enable = true;
    generateCompletions = true;
  };
}
