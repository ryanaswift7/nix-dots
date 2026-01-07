{ config, lib, pkgs, ... }:

let
  cfg = config.systemFeatures.minimal;
in
{
  options.systemFeatures.minimal = {
    enable = lib.mkEnableOption "minimal set of essential system tools, utilities, programs, etc.";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      vim
      wget
      curl
      pciutils
      usbutils
      htop
      speedtest-cli
      steam-run
      gptfdisk
      gettext
      envsubst
      unzip
      zip
      ripgrep
      fd
    ];

    programs.dconf.enable = true;
    services.fstrim.enable = true;
  };
}

