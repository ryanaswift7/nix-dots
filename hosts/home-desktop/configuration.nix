
{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

    # nvidia
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = false;
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

  specialisation."zen-kernel".configuration = {
    environment.etc."specialisation".text = "zen-kernel";
    system.nixos.tags = [ "zen-kernel" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
  };

  specialisation."gaming".configuration = {
    environment.etc."specialisation".text = "gaming";
    system.nixos.tags = [ "gaming" ];
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;

    boot.kernelParams = [ 
          "split_lock_mitigate=0" # Improves performance in some games by disabling a CPU mitigation
    ];

    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642; # Essential for heavy games like Star Citizen or Elden Ring
    };

    programs.gamemode.enable = true;
    programs.gamescope.enable = true; # Micro-compositor for better upscaling/latency
       
    environment.systemPackages = with pkgs; [
      mangohud    # On-screen FPS and performance overlay
      protonup-qt # Easy way to install GE-Proton versions
      lutris      # Launcher for non-Steam games
    ];

     powerManagement.cpuFreqGovernor = "performance";
  };


}
