{ config, lib, ... }:

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
    # --- HIERARCHY LOGIC ---
    # If you enable Gaming, it implies Workstation.
    # If you enable Workstation or Server, it implies Minimal.
    {
      systemSuites.workstation = lib.mkIf cfg.gaming (lib.mkDefault true);
      systemSuites.minimal = lib.mkIf (cfg.workstation || cfg.server) (lib.mkDefault true);
    }

    # --- MINIMAL SUITE ---
    # The foundation for every machine you own.
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
        minimal.enable = true; # References your minimal.nix feature
      };
    })

    # --- SERVER SUITE ---
    # Headless operations, containers, and remote access.
    (lib.mkIf cfg.server {
      systemFeatures = {
        ssh.enable = true;
        docker.enable = true;
        virtualization.host.enable = lib.mkDefault true;
      };
    })

    # --- WORKSTATION SUITE ---
    # Your daily driver desktop environment (includes NVIDIA by default).
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
      };
    })

    # --- GAMING SUITE ---
    # High-performance tools
    (lib.mkIf cfg.gaming {
      systemFeatures = {
        steam.enable = true;
        gamingTools.enable = true;
      };
    })
  ];
}
