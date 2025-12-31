{ config, lib, pkgs, ... }:

let
  cfg = config.features.minimal;
in
{
  options.features.minimal = {
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
    ];

    programs.dconf.enable = true;
    services.fstrim.enable = true;
  };
}

