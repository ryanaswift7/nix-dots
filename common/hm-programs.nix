# This is a Nix module that holds all your *enabled*
# user programs, which will be shared everywhere.
{ config, pkgs, niri, ... }:

{
  # --- All your shared, enabled programs go here ---
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Ryan Swift";
	email = "ryanaswift7@gmail.com";
      };
    };

    # userName = 
    # userEmail = "ryanaswift7@gmail.com";
  };

  # programs.starship = {
  #   enable = true;
  #   package = pkgs.starship;
  #   enableZshIntegration = true;
  # };


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

  programs.kitty = {
    enable = true;
  };

  programs.alacritty = {
    enable = true;
    # theme = "horizon_dark";
  };

  programs.niri = {
    enable = true;
    # package = niri-flake.packages.${pkgs.system}.niri;
  };

  programs.dankMaterialShell = {
    enable = true;
    niri = {
      enableKeybinds = true;  # Automatic keybinding configuration
      enableSpawn = true;      # Auto-start DMS with niri
    };
    quickshell.package = pkgs.unstable.quickshell;
  };

  programs.btop.enable = true;


}
