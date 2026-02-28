{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.gamingTools;
in
{
  options.systemFeatures.gamingTools = {
    enable = lib.mkEnableOption "General gaming tools (Wine, Gamemode, MangoHud)";
  };

  config = lib.mkIf cfg.enable {
    # Optimizes CPU/GPU frequency scaling while gaming
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
    };

    # Tools and Wrappers
    environment.systemPackages = with pkgs; [
      # Performance Overlay
      mangohud
      
      wineWowPackages.waylandFull
      winetricks
      
      gamescope-wsi  # for HDR
      
      # protonup-qt
      lutris
      heroic
      gamescope-wsi
      bottles
      steam-run
    ];

    # # Wayland Specific Gaming Environment Variables
    # environment.sessionVariables = {
    #   # Forces many older SDL2 games to use Wayland instead of Xwayland
    #   SDL_VIDEODRIVER = "wayland";
    #   # Fixes potential flickering in Wine/Proton games on Wayland
    #   _JAVA_AWT_WM_NONREPARENTING = "1";
    # };
    #
    #
    # boot.kernelParams = [ 
    #       "split_lock_mitigate=0" # Improves performance in some games by disabling a CPU mitigation
    # ];
    #
    # boot.kernel.sysctl = {
    #   "vm.max_map_count" = 2147483642; # Essential for heavy games like Star Citizen or Elden Ring
    # };
    #
    # powerManagement.cpuFreqGovernor = "performance";
    
    # need to get bottles from flathub
    services.flatpak.enable = true;
    # command to enable flathub
    # flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  };
}
