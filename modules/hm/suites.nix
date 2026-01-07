{ config, lib, ... }:

let
  cfg = config.homeSuites;
in
{
  options.homeSuites = {
    server      = lib.mkEnableOption "Core headless environment";
    workstation = lib.mkEnableOption "GUI and Dev environment (includes Server)";
    gaming      = lib.mkEnableOption "Gaming environment (includes Workstation)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.server {
      homeFeatures.zsh.enable = true;
      homeFeatures.git.enable = true;
      homeFeatures.fonts.enable = true;
      homeFeatures.neovim.enable = true;
      homeFeatures.ssh.enable = true;
    })

    (lib.mkIf cfg.workstation {
      homeSuites.server = lib.mkDefault true;
      
      homeFeatures.guiBasics.enable = true;
      homeFeatures.vscode.enable = true;
      homeFeatures.pointerCursor.enable = true;
      homeFeatures.niri.enable = true;
      homeFeatures.alacritty.enable = true;
    })

    (lib.mkIf cfg.gaming {
      homeSuites.workstation = lib.mkDefault true;
      
      homeFeatures.mangoHud.enable = true;
      homeFeatures.gameLaunchers.enable = true;
    })
  ];
}
