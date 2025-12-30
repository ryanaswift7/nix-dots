
{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # nvidia
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };

  specialisation."LTS".configuration = {
    environment.etc."specialisation".text = "LTS";
    system.nixos.tags = [ "LTS" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  specialisation."GAMING".configuration = {
    environment.etc."specialisation".text = "GAMING";
    system.nixos.tags = [ "GAMING" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    boot.kernelParams = [ 
          "split_lock_mitigate=0" # Improves performance in some games by disabling a CPU mitigation
    ];

    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642; # Essential for heavy games like Star Citizen or Elden Ring
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true; # Micro-compositor for better upscaling/latency

    programs.steam = {
      enable = true;
      # remotePlay.openFirewall = true;
      # dedicatedServer.openFirewall = true;
    };
       
    environment.systemPackages = with pkgs; [
      mangohud    # On-screen FPS and performance overlay
      protonup-qt # Easy way to install GE-Proton versions
      lutris      # Launcher for non-Steam games
      heroic
      wineWowPackages.waylandFull
      gamescope-wsi # HDR won't work without this
    ];

     powerManagement.cpuFreqGovernor = "performance";
  };


}
