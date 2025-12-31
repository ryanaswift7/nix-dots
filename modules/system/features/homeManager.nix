{ config, lib, ... }:

let
  cfg = config.systemFeatures.homeManager;
in
{
  options.systemFeatures.homeManager = {
    enable = lib.mkEnableOption "Home Manager NixOS integration";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      # If HM finds an existing file (like .bashrc), it renames it to .bashrc.preHM 
      # instead of failing the build.
      backupFileExtension = "preHM";

      # Use the system-wide nixpkgs
      # This saves disk space and ensures your system and home apps 
      # are always on the same version.
      useGlobalPkgs = true;

      # Install packages to /etc/profiles
      # This makes your HM-installed apps behave exactly like system-installed apps.
      useUserPackages = true;

      # Pass system-level variables into Home Manager modules
      # This is the "magic" that allows your HM modules to see 'osConfig' 
      # (your userSettings, etc.)
      extraSpecialArgs = { inherit (config) userSettings; };
    };
  };
}
