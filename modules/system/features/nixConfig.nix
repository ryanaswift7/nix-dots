{ config, lib, pkgs, userSettings, ... }:

{
  options.systemFeatures.nixConfig.enable = lib.mkEnableOption "Core Nix and System settings";

  config = lib.mkIf config.systemFeatures.nixConfig.enable {
    system.stateVersion = userSettings.systemStateVersion;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    environment.localBinInPath = true;

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 2";
      };
      flake = "${userSettings.homeDirectory}/nix-dots"; 
    };

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc zlib fuse3 icu nss openssl curl expat
    ];
  };
}
