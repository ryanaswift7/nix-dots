{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.neovim;
  dots = userSettings.dotfileDirectory;
in
{
  options.homeFeatures.neovim.enable = lib.mkEnableOption "Neovim with custom dotfiles";

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      
      # Optional: Add common dependencies for plugins (LSPs, etc.)
      extraPackages = with pkgs; [
        # --- Mason Essentials ---
        git           # For cloning
        curl          # For downloading
        unzip         # For extracting
        gnutar        # For extracting .tar.gz
        gzip
        ripgrep       # Required by telescope/many LSPs
        fd            # Required by telescope
        
        # --- Runtimes for LSPs ---
        # Most LSPs installed by Mason need these to run
        nodejs        # For Pyright, TS_Server, etc.
        python3       # For various Python tools
        go            # For Go-based tools
        
        # --- Build Tools ---
        # Required if Mason/Treesitter needs to compile something
        gcc
        gnumake
      ];
    };

    xdg.configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/nvim";
      recursive = true;
    };
  };
}
