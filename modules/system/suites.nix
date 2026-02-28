{ config, lib, pkgs, ... }:

let
  cfg = config.systemSuites;
in
{
  options.systemSuites = {
    minimal = lib.mkEnableOption "Minimal suite (CLI only, core system)";
    server = lib.mkEnableOption "Server suite (Minimal + Headless tools)";
    workstation = lib.mkEnableOption "Workstation suite (Minimal + GUI + Dev tools)";
    gaming = lib.mkEnableOption "Gaming suite (Workstation + Steam + Performance tools)";
  };

  config = lib.mkMerge [
    # --- SAFE HIERARCHY ---
    # We define the inheritance by looking at all "higher" tiers at once.
    # This prevents the "Minimal -> Server -> Workstation" chain reaction loop.
    {
      systemSuites.workstation = lib.mkIf cfg.gaming (lib.mkDefault true);
      
      systemSuites.server = lib.mkIf (cfg.workstation || cfg.gaming) (lib.mkDefault true);
      
      systemSuites.minimal = lib.mkIf (cfg.server || cfg.workstation || cfg.gaming) (lib.mkDefault true);
    }
    # --- MINIMAL SUITE (The Foundation) ---
    (lib.mkIf cfg.minimal {
      systemFeatures = {
        boot.enable = true;
        nixConfig.enable = true;
        networking.enable = true;
        locales.enable = true;
        keyboard.enable = true;
        users.enable = true;
        time.enable = true;
        neovim.enable = true;
        homeManager.enable = true;
        minimal.enable = true; 
      };
    })

    # --- SERVER SUITE (Minimal + Server Tools) ---
    (lib.mkIf cfg.server {
      systemFeatures = {
        ssh.enable = true;
        docker.enable = true;
        virtualization.host.enable = lib.mkDefault true;
      };
    })

    # --- WORKSTATION SUITE (Server + GUI) ---
    (lib.mkIf cfg.workstation {
      systemFeatures = {
        audio.enable = true;
        browsers.enable = true;
        udisks2.enable = true;
        printing.enable = lib.mkDefault true;
        x11.enable = lib.mkDefault true;
        distrobox.enable = true;
        gnome.enable = lib.mkDefault true; 
        niri.enable = lib.mkDefault true;
        nvidia.enable = lib.mkDefault true;
	bluetooth.enable = lib.mkDefault true;
	localsend.enable = lib.mkDefault true;
      };
    })

    # --- GAMING SUITE (Workstation + Performance) ---
    (lib.mkIf cfg.gaming {
      systemFeatures = {
        gamingTools.enable = true;
      };
      boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
    })
  ];
}
