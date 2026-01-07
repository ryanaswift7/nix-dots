{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.neovim;
in
{
  options.systemFeatures.neovim = {
    enable = lib.mkEnableOption "System-wide Neovim with sane defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true; # Sets the $EDITOR environment variable to nvim
      
      # Basic system-level config (useful for root/maintenance)
      configure = {
        customRC = ''
          set number         " Show line numbers
          set relativenumber " Relative line numbers for easier jumping
          set shiftwidth=2   " Nix files use 2 spaces
          set tabstop=2
          set expandtab
          set smartindent
          set mouse=a        " Enable mouse support
        '';
      };
    };

    # Essential for modern Neovim/LSP support in the terminal
    environment.systemPackages = with pkgs; [
      git      # Neovim plugins often need git to download
      ripgrep  # Essential for telescope/searching
      fd       # Faster file finding
    ];
  };
}
