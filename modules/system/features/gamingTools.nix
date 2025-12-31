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

    # Tools and Wrappers
    environment.systemPackages = with pkgs; [
      # Performance Overlay
      mangohud
      
      # Wine Management (Bottles is excellent for Wayland)
      bottles
      wineWowPackages.stable # 32-bit and 64-bit support
      winetricks
      
      # Wayland-native micro-compositor for better scaling/HDR
      gamescope
      
      protonup-qt
      lutris
      heroic
      gamescope-wsi
    ];

    # Wayland Specific Gaming Environment Variables
    environment.sessionVariables = {
      # Forces many older SDL2 games to use Wayland instead of Xwayland
      SDL_VIDEODRIVER = "wayland";
      # Fixes potential flickering in Wine/Proton games on Wayland
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };


    boot.kernelParams = [ 
          "split_lock_mitigate=0" # Improves performance in some games by disabling a CPU mitigation
    ];

    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642; # Essential for heavy games like Star Citizen or Elden Ring
    };

    powerManagement.cpuFreqGovernor = "performance";

  };
}
