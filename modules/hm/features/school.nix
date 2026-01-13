
{ config, lib, pkgs, ... }:

let
  cfg = config.homeFeatures.school;
in
{
  options.homeFeatures.school = {
    enable = lib.mkEnableOption "configuration specific to school (Zoom, OC-SSO, extra IDEs, etc.)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zoom-us
      unstable.antigravity-fhs
      # openconnect-sso
    ];
  };
}
