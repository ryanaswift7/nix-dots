{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.homeFeatures.ssh;
  dots = userSettings.dotfileDirectory;
in
{
  options.homeFeatures.ssh.enable = lib.mkEnableOption "SSH configuration with custom templates";

  config = lib.mkIf cfg.enable {
    home.file.".ssh/config.tmpl" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dots}/ssh/config.tmpl";
    };
  };
}
