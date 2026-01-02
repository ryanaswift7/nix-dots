{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.steam;
in
{
  options.systemFeatures.steam = {
    enable = lib.mkEnableOption "Steam and related optimizations";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false; 
      # Open ports in the firewall for Steam Local Network Game Transfers
      dedicatedServer.openFirewall = false; 
      
      # Use Gamescope: a micro-compositor that provides features like 
      # HDR support, upscaling (FSR), and better performance on Wayland.
      gamescopeSession.enable = true;
    };

    # Essential for Steam on Wayland/Nvidia
    environment.systemPackages = with pkgs; [
      steamcmd
    ];
  };
}
